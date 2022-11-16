import UIKit

class FeedViewController: UIViewController {
    // MARK: - UI elements
    private weak var mainView: FeedView?
    
    // MARK: - Sub properties
    // swiftlint:disable:next implicitly_unwrapped_optional
    var viewModel: FeedViewModelProtocol!
    // swiftlint:disable:previous implicitly_unwrapped_optional
    
    // MARK: - Life cycle
    override func loadView() {
        let feedView = FeedView()
        mainView = feedView
        view = feedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Главная"
        
        setUpRootView()
        setViewModelCallbacks()
        
        viewModel.getFeed()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setNavigationBarApppearance()
        mainView?.feedTableView.reloadData()
    }
    
    // MARK: - Sub methods
    private func setUpRootView() {
        mainView?.feedTableView.delegate = self
        mainView?.feedTableView.dataSource = self
        mainView?.delegate = self
    }
    
    private func setViewModelCallbacks() {
        viewModel.postLoaded = {
            self.mainView?.feedTableView.refreshControl?.endRefreshing()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.mainView?.feedTableView.reloadData()
            }
        }
        viewModel.postDidLiked = { cell in
            cell.bottomView.setLikeButton(post: cell.post)
        }
        viewModel.postDidSetFavourite = { cell in
            cell.bottomView.setFavouritesButton(post: cell.post)
        }
    }
    
    private func setNavigationBarApppearance() {
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Actions
    @objc private func userAvatarTapped(_ sender: UIView) {
        guard let cell = sender as? FeedTableViewCell, let author = cell.post?.author else {
            return
        }
        
        viewModel.showUserProfile(for: author)
    }
}

// MARK: - UITableViewDelegate implementation
extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ItemsIdentifier.feedSectionHeader.rawValue) as? FeedSectionView else {
            return nil
        }
        
        if viewModel.postsCollections.count < section {
            return nil
        }
        
        let collectionDate = viewModel.postsCollections[section].date
        
        let backgroundView = UIView(frame: header.frame)
        backgroundView.backgroundColor = .systemBackground
        
        header.setCell(data: collectionDate)
        header.backgroundView = backgroundView
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        view.frame.height / 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.showPostInfo(in: indexPath.section, of: indexPath.row)
    }
}

// MARK: - UITableViewDataSource implementation
extension FeedViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.postsCollections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.postsCollections[section].posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemsIdentifier.feedCell.rawValue, for: indexPath) as? FeedTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        cell.setCell(data: viewModel.postsCollections[indexPath.section].posts[indexPath.row])
        
        return cell
    }
}

extension FeedViewController: FeedTableViewCellDelegateProtocol {
    func titleDidTap(user: User?) {
        guard let author = user else {
            return
        }
        
        viewModel.showUserProfile(for: author)
    }
    
    func likeButtonDidTap(_ sender: FeedTableViewCell, post: Post?) {
        guard let currentPost = post else {
            return
        }
        
        viewModel.likePost(in: sender, post: currentPost)
    }
    
    func favouritesButtonDidTap(_ sender: FeedTableViewCell, post: Post?) {
        guard let currentPost = post else {
            return
        }
        
        viewModel.setPostInFavourites(in: sender, post: currentPost)
    }
}

extension FeedViewController: FeedViewDelegateProtocol {
    func refreshDataDidLaunch() {
        viewModel.getFeed()
    }
}
