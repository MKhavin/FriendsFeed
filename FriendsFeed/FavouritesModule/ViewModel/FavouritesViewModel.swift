import Foundation

protocol FavouritesViewModelProtocol {
    var favouritesPostsDidLoad: (() -> Void)? { get set }
    var postDidLiked: ((FeedTableViewCell) -> Void)? { get set }
    var postDidSetFavourite: ((IndexPath) -> Void)? { get set }
    func getFavouritesPosts()
    func getFavouritesPostsCount() -> Int
    func getPost(by postNumber: Int) -> Post
    func pushPostInfo(with data: Post)
    func likePost(cell: FeedTableViewCell, post: Post)
    func setPostInFavourites(cellPath: IndexPath, post: Post)
    func getCellPath(by post: Post) -> IndexPath?
}

class FavouritesViewModel: FavouritesViewModelProtocol {
    var favouritesPostsDidLoad: (() -> Void)?
    var postDidLiked: ((FeedTableViewCell) -> Void)?
    var postDidSetFavourite: ((IndexPath) -> Void)?
    private var model: FavouritesModelManagerProtocol?
    private var coordinator: FavouritesCoordinatorProtocol?
    
    init(model: FavouritesModelManagerProtocol?, coordinator: FavouritesCoordinatorProtocol?) {
        self.model = model
        self.model?.delegate = self
        
        self.coordinator = coordinator
    }
    
    func getFavouritesPosts() {
        model?.loadFavouritesPosts()
    }
    
    func getFavouritesPostsCount() -> Int {
        model?.posts.count ?? 0
    }
    
    func getPost(by postNumber: Int) -> Post {
        return model?.posts[postNumber] ?? Post(id: "",
                                                date: nil,
                                                likes: 0,
                                                text: nil,
                                                author: nil,
                                                image: nil)
    }
    
    func pushPostInfo(with data: Post) {
        coordinator?.pushPostInfoView(with: data)
    }
    
    func likePost(cell: FeedTableViewCell, post: Post) {
        model?.likePost(cell: cell, post: post)
    }
    
    func setPostInFavourites(cellPath: IndexPath, post: Post) {
        model?.setPostInFavourites(cellPath: cellPath, post: post)
    }
    
    func getCellPath(by post: Post) -> IndexPath? {
        let index = model?.posts.firstIndex { $0 === post }
        
        return index != nil ? IndexPath(row: index!, section: 0) : nil
    }
}

extension FavouritesViewModel: FavouritesModelManagerDelegateProtocol {
    func postBecomeFavourite(cellPath: IndexPath) {
        postDidSetFavourite?(cellPath)
    }
    
    func favouritePostDidLiked(cell: FeedTableViewCell) {
        postDidLiked?(cell)
    }
    
    func favouritesPostsLoadingFinished() {
        favouritesPostsDidLoad?()
    }
}
