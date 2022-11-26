import FirebaseAuth
import FirebaseFirestore

protocol PostInfoViewModelProtocol {
    var coordinator: NavigationCoordinatorProtocol? { get set }
    var postDataLoaded: ((Post) -> Void)? { get set }
    var postDidLiked: ((Post?) -> Void)? { get set }
    var postDidSetFavourite: ((Post?) -> Void)? { get set }
    func likePost()
    func loadPostData()
    func showProfileInfo()
    func getPost() -> Post
    func setPostInFavourites()
}

class PostInfoViewModel: PostInfoViewModelProtocol {
    var postDataLoaded: ((Post) -> Void)?
    var coordinator: NavigationCoordinatorProtocol?
    var postDidLiked: ((Post?) -> Void)?
    var postDidSetFavourite: ((Post?) -> Void)?
    private let post: Post
    
    init(coordinator: NavigationCoordinatorProtocol?, data: Post) {
        self.coordinator = coordinator
        self.post = data
    }
    
    func loadPostData() {
        postDataLoaded?(post)
    }
    
    func showProfileInfo() {
        guard let unwrappedCoordinator = coordinator else {
            return
        }
        
        let profileCoordinator = ProfileCoordinator(moduleFactory: unwrappedCoordinator.moduleFactory,
                                                    navigationController: unwrappedCoordinator.navigationController)
        profileCoordinator.pushProfileView(for: post.author, isCurrentUserProfile: false)
    }
    
    func likePost() {
        post.isLiked = !post.isLiked
        
        let db = Firestore.firestore()
        let reference = db.document("\(FirestoreTables.post.rawValue)/\(post.id)")
        let currentUserReference = db.document("\(FirestoreTables.user.rawValue)/\(FirebaseAuth.Auth.auth().currentUser?.uid ?? "")")
        
        if post.isLiked {
            post.likes += 1
            
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
                    
                    self?.postDidLiked?(self?.post)
                }
            }
        } else {
            post.likes -= 1
            
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
                
                self?.postDidLiked?(self?.post)
            }
        }
    }
    
    func getPost() -> Post {
        post
    }
    
    func setPostInFavourites() {
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
                    
                    self?.post.isFavourite = !(self?.post.isFavourite ?? false)
                    self?.postDidSetFavourite?(self?.post)
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
                
                self?.post.isFavourite = !(self?.post.isFavourite ?? false)
                self?.postDidSetFavourite?(self?.post)
            }
        }
    }
}
