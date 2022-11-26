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
        let userReference = db.document("\(FirestoreTables.user.rawValue)/\(FirebaseAuth.Auth.auth().currentUser?.uid ?? "")")
        
        asyncGroup.enter()
        db.collection(FirestoreTables.favouritesPosts.rawValue).whereField(
            FavouritesPostsTableColumns.user.rawValue,
            isEqualTo: userReference
        ).getDocuments { snapshot, error in
            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                print(error!.localizedDescription)
                // swiftlint:disable:previous force_unwrapping
                self.asyncGroup.leave()
                return
            }
            
            snapshot?.documents.forEach { snapshot in
                let documentData = snapshot.data()
                let postReference = documentData[FavouritesPostsTableColumns.post.rawValue] as? DocumentReference
                
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
                                    date: Date(timeIntervalSince1970: postData[PostTableColumns.date.rawValue] as? Double ?? 0.0),
                                    likes: 0,
                                    text: postData[PostTableColumns.text.rawValue] as? String,
                                    author: nil,
                                    image: postData[PostTableColumns.image.rawValue] as? String)
                    self.posts.append(post)
                    
                    self.loadFavouritesInfo(for: post)
                    self.loadLikesInfo(for: post)
                    self.loadUserInfo(for: post, user: documentData[FavouritesPostsTableColumns.user.rawValue] as? DocumentReference)
                    
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
        let reference = db.document("\(FirestoreTables.post.rawValue)/\(post.id)")
        let currentUserReference = db.document("\(FirestoreTables.user.rawValue)/\(FirebaseAuth.Auth.auth().currentUser?.uid ?? "")")
        
        asyncGroup.enter()
        db.collection(FirestoreTables.favouritesPosts.rawValue).whereField(
            FavouritesPostsTableColumns.post.rawValue,
            isEqualTo: reference
        ).whereField(
            FavouritesPostsTableColumns.user.rawValue,
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
        let reference = db.document("\(FirestoreTables.post.rawValue)/\(post.id)")
        let currentUserReference = db.document("\(FirestoreTables.user.rawValue)/\(FirebaseAuth.Auth.auth().currentUser?.uid ?? "")")
        
        asyncGroup.enter()
        db.collection(FirestoreTables.postsLikes.rawValue).whereField(
            PostsLikesTableColumns.post.rawValue,
            isEqualTo: reference
        ).getDocuments { snapshot, error in
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
                
                if let user = document.data()[PostsLikesTableColumns.user.rawValue] as? DocumentReference, user == currentUserReference {
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
                               firstName: userData[UserTableColumns.firstName.rawValue] as? String,
                               lastName: userData[UserTableColumns.lastName.rawValue] as? String,
                               birthDate: Date(timeIntervalSince1970: userData[UserTableColumns.birthDate.rawValue] as? Double ?? 0.0),
                               sex: .init(rawValue: userData[UserTableColumns.sex.rawValue] as? String ?? "") ?? .male,
                               avatar: userData[UserTableColumns.avatar.rawValue] as? String,
                               phoneNumber: userData[UserTableColumns.phoneNumber.rawValue] as? String)
        
            self.asyncGroup.leave()
        }
    }
    
    func likePost(cell: FeedTableViewCell, post: Post) {
        let db = Firestore.firestore()
        let reference = db.document("\(FirestoreTables.post.rawValue)/\(post.id)")
        let currentUserReference = db.document("\(FirestoreTables.user.rawValue)/\(FirebaseAuth.Auth.auth().currentUser?.uid ?? "")")
        
        if post.isLiked {
            db.collection(FirestoreTables.postsLikes.rawValue).whereField(
                PostsLikesTableColumns.post.rawValue,
                isEqualTo: reference
            ).whereField(
                PostsLikesTableColumns.user.rawValue,
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
                PostsLikesTableColumns.post.rawValue: reference,
                PostsLikesTableColumns.user.rawValue: currentUserReference
            ]
            db.collection(FirestoreTables.postsLikes.rawValue).addDocument(data: documentData) {[ weak self ] error in
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
        let reference = db.document("\(FirestoreTables.post.rawValue)/\(post.id)")
        let currentUserReference = db.document("\(FirestoreTables.user.rawValue)/\(FirebaseAuth.Auth.auth().currentUser?.uid ?? "")")
        
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
