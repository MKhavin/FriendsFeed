import UIKit

class FavouritesViewController: UIViewController {
    private weak var mainView: FavouritesView?
    // swiftlint:disable:next implicitly_unwrapped_optional
    var viewModel: FavouritesViewModelProtocol!
    // swiftlint:disable:previous implicitly_unwrapped_optional
    
    override func loadView() {
        let currentView = FavouritesView()
        mainView = currentView
        view = currentView
        mainView?.favouritesTableView.dataSource = self
        mainView?.favouritesTableView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        title = "Сохраненные"
        viewModel.favouritesPostsDidLoad = {
            self.mainView?.favouritesTableView.reloadData()
//            self.scrollCollectionToTop()
        }
        viewModel.postDidLiked = { cell in
            cell.bottomView.setLikeButton(post: cell.post)
        }
        viewModel.postDidSetFavourite = { cellPath in
            self.mainView?.favouritesTableView.deleteRows(at: [cellPath], with: .fade)
        }
        viewModel.getFavouritesPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainView?.favouritesTableView.reloadData()
    }
    
//    private func scrollCollectionToTop() {
//        let topRow = IndexPath(row: 0,
//                               section: 0)
//        likedPostsTableView.scrollToRow(at: topRow,
//                                        at: .top,
//                                        animated: false)
//    }
}

// MARK: Liked post table biew data source
extension FavouritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getFavouritesPostsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemsIdentifier.favouritesPostCell.rawValue,
                                                       for: indexPath) as? FeedTableViewCell else {
            return UITableViewCell()
        }
        
        let currentPost = viewModel.getPost(by: indexPath.row)
        cell.delegate = self
        cell.setCell(data: currentPost)
        return cell
    }
}

extension FavouritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.frame.height / 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = viewModel.getPost(by: indexPath.row)
        viewModel.pushPostInfo(with: post)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FavouritesViewController: FeedTableViewCellDelegateProtocol {
    func likeButtonDidTap(_ sender: FeedTableViewCell, post: Post?) {
        guard let value = post else {
            return
        }
        
        viewModel.likePost(cell: sender, post: value)
    }
    
    func favouritesButtonDidTap(_ sender: FeedTableViewCell, post: Post?) {
        guard let value = post, let cellPath = viewModel.getCellPath(by: value) else {
            return
        }
        
        viewModel.setPostInFavourites(cellPath: cellPath, post: value)
    }
}
