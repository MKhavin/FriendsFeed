import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

// MARK: - Profile model manager protocol
protocol ProfileModelManagerProtocol {
    var delegate: ProfileModelManagerDelegate? { get set }
    var posts: [Post] { get }
    var profile: User? { get }
    func loadUserData()
}

// MARK: - Profile model manager deleagte protocol
protocol ProfileModelManagerDelegate: AnyObject {
    func userDataDidLoad(_ result: Result<User?, Error>)
    func postDataDidLoad(_ error: Error?)
}

class ProfileModelManager: ProfileModelManagerProtocol {
    enum SubInformationData {
        case postsCount
        case subscriptionsCount
        case friendsCount
        
        func getCollectionName() -> String {
            switch self {
            case .postsCount:
                return "Post"
            case .subscriptionsCount, .friendsCount:
                return "Subscription"
            }
        }
    }
    
    // MARK: - Properties
    private let group: DispatchGroup = DispatchGroup()
    private var currentLogin: String!
    private(set) var posts: [Post] = []
    private(set) var profile: User?
    weak var delegate: ProfileModelManagerDelegate?
    
    // MARK: - Life cycle
    init(profile: User?) {
        self.profile = profile
    }
    
    // MARK: - Main methods
    func loadUserData() {
        if profile?.phoneNumber == nil {
            if let user = Auth.auth().currentUser, let phone = user.phoneNumber {
                currentLogin = phone
            } else {
              return
            }
        } else {
            currentLogin = profile!.phoneNumber
        }
        
        group.enter()
        let db = Firestore.firestore()
        
        db.collection("User").whereField("phoneNumber", isEqualTo: currentLogin!).getDocuments { [ weak self ] (querySnapshot, error) in
            guard error == nil else {
                self?.group.leave()
                // swiftlint:disable:next force_unwrapping
                print(error!.localizedDescription)
                self?.delegate?.userDataDidLoad(.failure(error!))
                // swiftlint:disable:previous force_unwrapping
                return
            }
            
            querySnapshot?.documents.forEach({ [weak self] snapshot in
                let userData = snapshot.data()
                let documentId = snapshot.documentID
                
                self?.profile = User(
                    id: snapshot.documentID,
                    firstName: userData["firstName"] as? String,
                    lastName: userData["lastName"] as? String,
                    birthDate: userData["birthDate"] as? Date,
                    sex: .init(rawValue: userData["sex"] as? String ?? "male") ?? .male,
                    avatar: userData["avatar"] as? String,
                    phoneNumber: userData["phoneNumber"] as? String
                )
                
                self?.getSubInformation(.postsCount, for: documentId)
                self?.getSubInformation(.subscriptionsCount, for: documentId, field: "user")
                self?.getSubInformation(.friendsCount, for: documentId, field: "subscription")
                self?.group.leave()
            })
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.delegate?.userDataDidLoad(.success(self?.profile))
            self?.loadPostsData()
        }
    }
    
    private func getSubInformation(_ type: SubInformationData, for userId: String, field: String = "User") {
        let db = Firestore.firestore()
        let reference = db.document("User/\(userId)")
        
        group.enter()
        db.collection(type.getCollectionName()).whereField(field, isEqualTo: reference).getDocuments { [ weak self ] snapshot, error in
            guard error == nil else {
                self?.group.leave()
                // swiftlint:disable:next force_unwrapping
                self?.delegate?.userDataDidLoad(.failure(error!))
                print(error!.localizedDescription)
                // swiftlint:disable:previous force_unwrapping
                return
            }
            
            switch type {
            case .postsCount:
                self?.profile?.postsCount = snapshot?.documents.count ?? 0
            case .subscriptionsCount:
                self?.profile?.subscriptions = snapshot?.documents.count ?? 0
            case .friendsCount:
                self?.profile?.friends = snapshot?.documents.count ?? 0
            }

            self?.group.leave()
        }
    }
    
    private func loadPostsData() {
        let db = Firestore.firestore()
        let userReference = db.document("User/\(profile?.id ?? "")")
        
        group.enter()
        db.collection("Post").whereField("User", isEqualTo: userReference).getDocuments { [ weak self ] snapshot, error in
            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                print(error!.localizedDescription)
                self?.delegate?.postDataDidLoad(error!)
                // swiftlint:disable:previous force_unwrapping
                self?.group.leave()
                return
            }
            
            self?.posts = snapshot?.documents.map { document -> Post in
                let postData = document.data()
                
                let post = Post(
                    id: document.documentID,
                    date: Date(timeIntervalSince1970: postData["Date"] as? Double ?? 0),
                    likes: postData["Likes"] as? UInt ?? 0,
                    text: postData["Text"] as? String,
                    author: self?.profile, //????
                    image: postData["image"] as? String
                )
                
                self?.loadFavouritesInfo(for: post)
                self?.loadLikesInfo(for: post)
                
                return post
            } ?? []
            
            self?.group.leave()
        }
        
        self.group.notify(queue: .main) {
            self.delegate?.postDataDidLoad(nil)
        }
    }
    
    private func loadFavouritesInfo(for post: Post) {
        let db = Firestore.firestore()
        let reference = db.document("Post/\(post.id)")
        let currentUserReference = db.document("User/\(FirebaseAuth.Auth.auth().currentUser?.uid ?? "")")
        
        group.enter()
        db.collection("FavouritesPosts").whereField(
            "post",
            isEqualTo: reference
        ).whereField(
            "user",
            isEqualTo: currentUserReference
        ).getDocuments { [ weak self ] snapshot, error in
            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                print(error!.localizedDescription)
                // swiftlint:disable:previous force_unwrapping
                self?.group.leave()
                return
            }
            
            for _ in snapshot!.documents {
                post.isFavourite = true
            }
            self?.group.leave()
        }
    }
    
    private func loadLikesInfo(for post: Post) {
        let db = Firestore.firestore()
        let reference = db.document("Post/\(post.id)")
        let currentUserReference = db.document("User/\(FirebaseAuth.Auth.auth().currentUser?.uid ?? "")")
        
        group.enter()
        db.collection("PostsLikes").whereField("post", isEqualTo: reference).getDocuments { snapshot, error in
            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                print(error!.localizedDescription)
                // swiftlint:disable:previous force_unwrapping
                self.group.leave()
                return
            }
            
            for document in snapshot!.documents {
                post.likes += 1
                if let user = document.data()["user"] as? DocumentReference, user == currentUserReference {
                    post.isLiked = true
                }
            }
            self.group.leave()
        }
    }
}
