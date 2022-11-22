import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

protocol FeedViewModelProtocol {
    var errorMessageChanged: ((String) -> Void)? { get set }
    var postLoaded: (() -> Void)? { get set }
    var postDidLiked: ((FeedTableViewCell) -> Void)? { get set }
    var postDidSetFavourite: ((FeedTableViewCell) -> Void)? { get set }
    var postsCollections: [PostCollection] { get set }
    func getFeed()
    func showPostInfo(in collection: Int, of post: Int)
    func showUserProfile(for user: User)
    func likePost(in cell: FeedTableViewCell, post: Post)
    func setPostInFavourites(in cell: FeedTableViewCell, post: Post)
}

class FeedViewModel: FeedViewModelProtocol {
    private var coordinator: FeedCoordinatorProtocol?
    var postLoaded: (() -> Void)?
    var errorMessageChanged: ((String) -> Void)?
    var postsCollections: [PostCollection] = []
    var postDidLiked: ((FeedTableViewCell) -> Void)?
    var postDidSetFavourite: ((FeedTableViewCell) -> Void)?
    
    init(coordinator: FeedCoordinatorProtocol?) {
        self.coordinator = coordinator
    }
    
    func getFeed() {
        postsCollections = []
        
        let db = Firestore.firestore()
        let operationGroup = DispatchGroup()
        
        operationGroup.enter()
        DispatchQueue.global(qos: .userInitiated).async(group: operationGroup) {
            let reference = db.document("\(FirestoreTables.user.rawValue)/\(FirebaseAuth.Auth.auth().currentUser?.uid ?? "")")
            
            db.collection(FirestoreTables.post.rawValue).whereField(PostTableColumns.user.rawValue,
                                             isNotEqualTo: reference).getDocuments { (querySnapshot, error) in
                
                guard error == nil else {
                    // swiftlint:disable:next force_unwrapping
                    self.errorMessageChanged?(error!.localizedDescription)
                    // swiftlint:disable:previous force_unwrapping
                    operationGroup.leave()
                    return
                }
                
                guard let documentsSnapshot = querySnapshot else {
                    print("Error occured while unwrapped feed snapshot")
                    return
                }
                
                for document in documentsSnapshot.documents {
                    self.processPost(document: document, on: operationGroup)
                }
                
                operationGroup.leave()
            }
        }
        
        operationGroup.notify(queue: DispatchQueue.main) {
            self.postsCollections.sort {
                $0.date < $1.date
            }
            self.postLoaded?()
        }
    }
    
    private func processPost(document: QueryDocumentSnapshot, on operationGroup: DispatchGroup?) {
        let data = document.data()
        
        if let userData = data[PostTableColumns.user.rawValue] as? DocumentReference {
            operationGroup?.enter()
            userData.getDocument { querySnapshot, error in
                guard error == nil else {
                    // swiftlint:disable:next force_unwrapping
                    self.errorMessageChanged?(error!.localizedDescription)
                    // swiftlint:disable:previous force_unwrapping
                    operationGroup?.leave()
                    return
                }
                
                guard let documentsSnapshot = querySnapshot, let snapshotData = documentsSnapshot.data() else {
                    print("Error occured while unwrapping post feed snapshot")
                    return
                }
                
                let currentAuthor = User(
                    id: documentsSnapshot.documentID,
                    firstName: snapshotData[UserTableColumns.firstName.rawValue] as? String,
                    lastName: snapshotData[UserTableColumns.lastName.rawValue] as? String,
                    birthDate: nil,
                    sex: .init(rawValue: (snapshotData[UserTableColumns.sex.rawValue] as? String) ?? "male") ?? .male,
                    avatar: snapshotData[UserTableColumns.avatar.rawValue] as? String,
                    phoneNumber: snapshotData[UserTableColumns.phoneNumber.rawValue] as? String
                )
                
                let currentPost = Post(id: document.documentID,
                                       date: (data[PostTableColumns.date.rawValue] as? Timestamp)?.dateValue(),
                                       likes: 0,
                                       text: data[PostTableColumns.text.rawValue] as? String,
                                       author: currentAuthor,
                                       image: data[PostTableColumns.image.rawValue] as? String)
                
                self.loadLikesInfo(for: currentPost, on: operationGroup)
                self.loadFavouritesInfo(for: currentPost, on: operationGroup)
                
                let postCollection = self.postsCollections.firstIndex { collection in
                    collection.date.formatted(by: "MM/dd/yyyy") == currentPost.date.formatted(by: "MM/dd/yyyy")
                }
                
                if postCollection == nil {
                    self.postsCollections.append(PostCollection(date: currentPost.date, posts: [currentPost]))
                } else {
                    // swiftlint:disable:next force_unwrapping
                    self.postsCollections[postCollection!].posts.append(currentPost)
                    // swiftlint:disable:previous force_unwrapping
                }
                
                operationGroup?.leave()
            }
        }
    }
    
    private func loadFavouritesInfo(for post: Post, on group: DispatchGroup?) {
        let db = Firestore.firestore()
        let reference = db.document("\(FirestoreTables.post.rawValue)/\(post.id)")
        let currentUserReference = db.document("\(FirestoreTables.user.rawValue)/\(FirebaseAuth.Auth.auth().currentUser?.uid ?? "")")
        
        group?.enter()
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
                group?.leave()
                return
            }
            
            guard let documentsSnapshot = snapshot else {
                print("Error occured while loading feed favourites info snapshot")
                return
            }
            
            for _ in documentsSnapshot.documents {
                post.isFavourite = true
            }
            group?.leave()
        }
    }
    
    private func loadLikesInfo(for post: Post, on group: DispatchGroup?) {
        let db = Firestore.firestore()
        let reference = db.document("\(FirestoreTables.post.rawValue)/\(post.id)")
        let currentUserReference = db.document("\(FirestoreTables.user.rawValue)/\(FirebaseAuth.Auth.auth().currentUser?.uid ?? "")")
        
        group?.enter()
        db.collection(FirestoreTables.postsLikes.rawValue).whereField(PostsLikesTableColumns.post.rawValue, isEqualTo: reference).getDocuments { snapshot, error in
            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                print(error!.localizedDescription)
                // swiftlint:disable:previous force_unwrapping
                group?.leave()
                return
            }
            
            guard let documentsSnapshot = snapshot else {
                print("Error occured while loading feed favourites info snapshot")
                return
            }
            
            for document in documentsSnapshot.documents {
                post.likes += 1
                if let user = document.data()[PostsLikesTableColumns.user.rawValue] as? DocumentReference, user == currentUserReference {
                    post.isLiked = true
                }
            }
            group?.leave()
        }
    }
    
    func showPostInfo(in collection: Int, of post: Int) {
        let data = postsCollections[collection].posts[post]
        coordinator?.pushPostInfoView(with: data)
    }
    
    func showUserProfile(for user: User) {
        guard let moduleFactory = coordinator?.moduleFactory, let navigationController = coordinator?.navigationController else {
            return
        }
        
        let profileCoordinator = ProfileCoordinator(moduleFactory: moduleFactory,
                                                    navigationController: navigationController)
        profileCoordinator.pushProfileView(for: user, isCurrentUserProfile: false)
    }
    
    func likePost(in cell: FeedTableViewCell, post: Post) {
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
                    
                    self?.postDidLiked?(cell)
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
                
                self?.postDidLiked?(cell)
            }
        }
    }
    
    func setPostInFavourites(in cell: FeedTableViewCell, post: Post) {
        let db = Firestore.firestore()
        let reference = db.document("\(FirestoreTables.post.rawValue)/\(post.id)")
        let currentUserReference = db.document("\(FirestoreTables.user.rawValue)/\(FirebaseAuth.Auth.auth().currentUser?.uid ?? "")")
        
        if post.isFavourite {
            db.collection(FirestoreTables.favouritesPosts.rawValue).whereField(
                FavouritesPostsTableColumns.post.rawValue,
                isEqualTo: reference
            ).whereField(
                FavouritesPostsTableColumns.user.rawValue,
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
                    
                    post.isFavourite = !post.isFavourite
                    self?.postDidSetFavourite?(cell)
                }
            }
        } else {
            let documentData = [
                FavouritesPostsTableColumns.post.rawValue: reference,
                FavouritesPostsTableColumns.user.rawValue: currentUserReference
            ]
            db.collection(FirestoreTables.favouritesPosts.rawValue).addDocument(data: documentData) {[ weak self ] error in
                guard error == nil else {
                    // swiftlint:disable:next force_unwrapping
                    print(error!.localizedDescription)
                    // swiftlint:disable:previous force_unwrapping
                    return
                }
                
                post.isFavourite = !post.isFavourite
                self?.postDidSetFavourite?(cell)
            }
        }
    }
}
