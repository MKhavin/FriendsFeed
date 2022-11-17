import FirebaseAuth
import FirebaseFirestore

protocol FavouritesModelManagerDelegateProtocol: AnyObject {
    func favouritesPostsLoadingFinished()
    func favouritePostDidLiked(cell: FeedTableViewCell)
    func postBecomeFavourite(cellPath: IndexPath)
}

protocol FavouritesModelManagerProtocol {
    var posts: [Post] { get }
    var delegate: FavouritesModelManagerDelegateProtocol? { get set }
    func loadFavouritesPosts()
    func likePost(cell: FeedTableViewCell, post: Post)
    func setPostInFavourites(cellPath: IndexPath, post: Post)
}

class FavouritesModelManager: FavouritesModelManagerProtocol {
    private let asyncGroup = DispatchGroup()
    private(set) var posts: [Post] = []
    weak var delegate: FavouritesModelManagerDelegateProtocol?
    
    func loadFavouritesPosts() {
        posts = []
        
        let db = Firestore.firestore()
        let userReference = db.document("User/\(FirebaseAuth.Auth.auth().currentUser?.uid ?? "")")
        
        asyncGroup.enter()
        db.collection("FavouritesPosts").whereField("user", isEqualTo: userReference).getDocuments { snapshot, error in
            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                print(error!.localizedDescription)
                // swiftlint:disable:previous force_unwrapping
                self.asyncGroup.leave()
                return
            }
            
            snapshot?.documents.forEach { snapshot in
                let documentData = snapshot.data()
                let postReference = documentData["post"] as? DocumentReference
                
                self.asyncGroup.enter()
                postReference?.getDocument { snapshot, error in
                    guard error == nil else {
                        // swiftlint:disable:next force_unwrapping
                        print(error!.localizedDescription)
                        // swiftlint:disable:previous force_unwrapping
                        self.asyncGroup.leave()
                        return
                    }
                    
                    guard let documentSnapshot = snapshot, let postData = documentSnapshot.data() else {
                        print("Error occured while unwrapped favourites posts snapshot data")
                        return
                    }
                    
                    let post = Post(id: documentSnapshot.documentID,
                                    date: Date(timeIntervalSince1970: postData["Date"] as? Double ?? 0.0),
                                    likes: 0,
                                    text: postData["Text"] as? String,
                                    author: nil,
                                    image: postData["image"] as? String)
                    self.posts.append(post)
                    
                    self.loadFavouritesInfo(for: post)
                    self.loadLikesInfo(for: post)
                    self.loadUserInfo(for: post, user: documentData["user"] as? DocumentReference)
                    
                    self.asyncGroup.leave()
                }
            }
            
            self.asyncGroup.leave()
        }
        
        asyncGroup.notify(queue: .main) {
            self.delegate?.favouritesPostsLoadingFinished()
        }
    }
    
    private func loadFavouritesInfo(for post: Post) {
        let db = Firestore.firestore()
        let reference = db.document("Post/\(post.id)")
        let currentUserReference = db.document("User/\(FirebaseAuth.Auth.auth().currentUser?.uid ?? "")")
        
        asyncGroup.enter()
        db.collection("FavouritesPosts").whereField(
            "post",
            isEqualTo: reference
        ).whereField(
            "user",
            isEqualTo: currentUserReference
        ).getDocuments { snapshot, error in
            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                print(error!.localizedDescription)
                // swiftlint:disable:previous force_unwrapping
                self.asyncGroup.leave()
                return
            }
            
            guard let documentsSnapshot = snapshot else {
                print("Error occured while unwrapped favourites posts info snapshot")
                return
            }
            
            for _ in documentsSnapshot.documents {
                post.isFavourite = true
            }
            self.asyncGroup.leave()
        }
    }
    
    private func loadLikesInfo(for post: Post) {
        let db = Firestore.firestore()
        let reference = db.document("Post/\(post.id)")
        let currentUserReference = db.document("User/\(FirebaseAuth.Auth.auth().currentUser?.uid ?? "")")
        
        asyncGroup.enter()
        db.collection("PostsLikes").whereField("post", isEqualTo: reference).getDocuments { snapshot, error in
            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                print(error!.localizedDescription)
                // swiftlint:disable:previous force_unwrapping
                self.asyncGroup.leave()
                return
            }
            
            guard let documentsSnapshot = snapshot else {
                print("Error occured while unwrapped favourites posts liked info data")
                return
            }
            
            for document in documentsSnapshot.documents {
                post.likes += 1
                
                if let user = document.data()["user"] as? DocumentReference, user == currentUserReference {
                    post.isLiked = true
                }
            }
            self.asyncGroup.leave()
        }
    }
    
    private func loadUserInfo(for post: Post, user: DocumentReference?) {
        guard let userReference = user else {
            return
        }
        
        asyncGroup.enter()
        userReference.getDocument { snapshot, error in
            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                print(error!.localizedDescription)
                // swiftlint:disable:previous force_unwrapping
                self.asyncGroup.leave()
                return
            }
            
            guard let documentSnapshot = snapshot, let userData = documentSnapshot.data() else {
                print("Error occured while unwrapped user info of favourites posts")
                return
            }
            
            post.author = User(id: snapshot?.documentID ?? "",
                               firstName: userData["firstName"] as? String,
                               lastName: userData["lastName"] as? String,
                               birthDate: Date(timeIntervalSince1970: userData["birthDate"] as? Double ?? 0.0),
                               sex: .init(rawValue: userData["sex"] as? String ?? "") ?? .male,
                               avatar: userData["avatar"] as? String,
                               phoneNumber: userData["phoneNumber"] as? String)
        
            self.asyncGroup.leave()
        }
    }
    
    func likePost(cell: FeedTableViewCell, post: Post) {
        let db = Firestore.firestore()
        let reference = db.document("Post/\(post.id)")
        let currentUserReference = db.document("User/\(FirebaseAuth.Auth.auth().currentUser?.uid ?? "")")
        
        if post.isLiked {
            db.collection("PostsLikes").whereField(
                "post",
                isEqualTo: reference
            ).whereField(
                "user",
                isEqualTo: currentUserReference
            ).getDocuments {[ weak self ] snapshot, error in
                guard error == nil else {
                    // swiftlint:disable:next force_unwrapping
                    print(error!.localizedDescription)
                    // swiftlint:disable:previous force_unwrapping
                    return
                }
                
                let document = snapshot?.documents[0].reference
                document?.delete { error in
                    guard error == nil else {
                        // swiftlint:disable:next force_unwrapping
                        print(error!.localizedDescription)
                        // swiftlint:disable:previous force_unwrapping
                        return
                    }
                    
                    post.isLiked = !post.isLiked
                    post.likes -= 1
                    
                    self?.delegate?.favouritePostDidLiked(cell: cell)
                }
            }
        } else {
            let documentData = [
                "post": reference,
                "user": currentUserReference
            ]
            db.collection("PostsLikes").addDocument(data: documentData) {[ weak self ] error in
                guard error == nil else {
                    // swiftlint:disable:next force_unwrapping
                    print(error!.localizedDescription)
                    // swiftlint:disable:previous force_unwrapping
                    return
                }
                
                post.isLiked = !post.isLiked
                post.likes += 1
                
                self?.delegate?.favouritePostDidLiked(cell: cell)
            }
        }
    }
    
    func setPostInFavourites(cellPath: IndexPath, post: Post) {
        let db = Firestore.firestore()
        let reference = db.document("Post/\(post.id)")
        let currentUserReference = db.document("User/\(FirebaseAuth.Auth.auth().currentUser?.uid ?? "")")
        
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
                return
            }
            
            let document = snapshot?.documents[0].reference
            document?.delete { error in
                guard error == nil else {
                    // swiftlint:disable:next force_unwrapping
                    print(error!.localizedDescription)
                    // swiftlint:disable:previous force_unwrapping
                    return
                }
                
                self?.posts.removeAll { $0 === post }
                self?.delegate?.postBecomeFavourite(cellPath: cellPath)
            }
        }
    }
}
