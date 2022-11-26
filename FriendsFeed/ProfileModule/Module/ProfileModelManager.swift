import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

// MARK: - Profile model manager protocol
protocol ProfileModelManagerProtocol {
    var delegate: ProfileModelManagerDelegate? { get set }
    var posts: [Post] { get }
    var profile: User? { get }
    func loadUserData()
    func logOut()
}

// MARK: - Profile model manager deleagte protocol
protocol ProfileModelManagerDelegate: AnyObject {
    func userDataDidLoad(_ result: Result<User?, Error>)
    func postDataDidLoad(_ error: Error?)
    func userDidLogOut()
}

class ProfileModelManager: ProfileModelManagerProtocol {
    enum SubInformationData {
        case postsCount
        case subscriptionsCount
        case friendsCount
        
        func getCollectionName() -> String {
            switch self {
            case .postsCount:
                return FirestoreTables.post.rawValue
            case .subscriptionsCount, .friendsCount:
                return FirestoreTables.subscription.rawValue
            }
        }
    }
    
    // MARK: - Properties
    private let group: DispatchGroup = DispatchGroup()
    private var currentLogin: String?
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
            currentLogin = profile?.phoneNumber
        }
        
        group.enter()
        let db = Firestore.firestore()
        
        db.collection(FirestoreTables.user.rawValue).whereField(
            UserTableColumns.phoneNumber.rawValue,
            isEqualTo: currentLogin ?? ""
        ).getDocuments { [ weak self ] (querySnapshot, error) in
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
                    firstName: userData[UserTableColumns.firstName.rawValue] as? String,
                    lastName: userData[UserTableColumns.lastName.rawValue] as? String,
                    birthDate: userData[UserTableColumns.birthDate.rawValue] as? Date,
                    sex: .init(rawValue: userData[UserTableColumns.sex.rawValue] as? String ?? "male") ?? .male,
                    avatar: userData[UserTableColumns.avatar.rawValue] as? String,
                    phoneNumber: userData[UserTableColumns.phoneNumber.rawValue] as? String
                )
                
                self?.getSubInformation(.postsCount, for: documentId, field: PostTableColumns.user.rawValue)
                self?.getSubInformation(.subscriptionsCount, for: documentId, field: SubscriptionTableColumns.user.rawValue)
                self?.getSubInformation(.friendsCount, for: documentId, field: SubscriptionTableColumns.subscription.rawValue)
                self?.group.leave()
            })
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.delegate?.userDataDidLoad(.success(self?.profile))
            self?.loadPostsData()
        }
    }
    
    private func getSubInformation(_ type: SubInformationData, for userId: String, field: String) {
        let db = Firestore.firestore()
        let reference = db.document("\(FirestoreTables.user.rawValue)/\(userId)")
        
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
        let userReference = db.document("\(FirestoreTables.user.rawValue)/\(profile?.id ?? "")")
        
        group.enter()
        db.collection(FirestoreTables.post.rawValue).whereField(
            PostTableColumns.user.rawValue,
            isEqualTo: userReference
        ).getDocuments { [ weak self ] snapshot, error in
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
                    date: Date(timeIntervalSince1970: postData[PostTableColumns.date.rawValue] as? Double ?? 0),
                    likes: 0,
                    text: postData[PostTableColumns.text.rawValue] as? String,
                    author: self?.profile,
                    image: postData[PostTableColumns.image.rawValue] as? String
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
        let reference = db.document("\(FirestoreTables.post.rawValue)/\(post.id)")
        let currentUserReference = db.document("\(FirestoreTables.user.rawValue)/\(FirebaseAuth.Auth.auth().currentUser?.uid ?? "")")
        
        group.enter()
        db.collection(FirestoreTables.favouritesPosts.rawValue).whereField(
            FavouritesPostsTableColumns.post.rawValue,
            isEqualTo: reference
        ).whereField(
            FavouritesPostsTableColumns.user.rawValue,
            isEqualTo: currentUserReference
        ).getDocuments { [ weak self ] snapshot, error in
            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                print(error!.localizedDescription)
                // swiftlint:disable:previous force_unwrapping
                self?.group.leave()
                return
            }
            
            guard let documentsSnapshot = snapshot else {
                print("Error occured while unwrapping profile favourites info snapshot")
                return
            }
            
            for _ in documentsSnapshot.documents {
                post.isFavourite = true
            }
            self?.group.leave()
        }
    }
    
    private func loadLikesInfo(for post: Post) {
        let db = Firestore.firestore()
        let reference = db.document("\(FirestoreTables.post.rawValue)/\(post.id)")
        let currentUserReference = db.document("\(FirestoreTables.user.rawValue)/\(FirebaseAuth.Auth.auth().currentUser?.uid ?? "")")
        
        group.enter()
        db.collection(FirestoreTables.postsLikes.rawValue).whereField(
            PostsLikesTableColumns.post.rawValue,
            isEqualTo: reference
        ).getDocuments { snapshot, error in
            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                print(error!.localizedDescription)
                // swiftlint:disable:previous force_unwrapping
                self.group.leave()
                return
            }
            
            guard let documentsSnapshot = snapshot else {
                print("Error occured while unwrapping likes info snapshot")
                return
            }
            
            for document in documentsSnapshot.documents {
                post.likes += 1
                if let user = document.data()[PostsLikesTableColumns.user.rawValue] as? DocumentReference, user == currentUserReference {
                    post.isLiked = true
                }
            }
            self.group.leave()
        }
    }
    
    func logOut() {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            delegate?.userDidLogOut()
        } catch {
            print("Sign-out error")
        }
    }
}
