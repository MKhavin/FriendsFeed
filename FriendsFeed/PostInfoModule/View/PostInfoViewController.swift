import UIKit

class PostInfoViewController: UIViewController {
    // MARK: - Sub properties
    // swiftlint:disable:next implicitly_unwrapped_optional
    var viewModel: PostInfoViewModelProtocol!
    // swiftlint:disable:previous implicitly_unwrapped_optional
    private weak var mainView: PostInfoView?
    
    // MARK: - Life cycle
    override func loadView() {
        let currentView = PostInfoView()
        mainView = currentView
        view = currentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Публикации"
        
        setViewModelCallbacks()
        viewModel.loadPostData()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(postTitleDidTap(_:)))
        mainView?.postTitleView.addGestureRecognizer(tapGesture)
        mainView?.postBottomView.likeButton.addTarget(self, action: #selector(likeButtonDidTap), for: .touchUpInside)
        mainView?.postBottomView.favouritesButton.addTarget(self, action: #selector(favouritesButtonDidTap), for: .touchUpInside)
        mainView?.postBottomView.setLikeButton(post: viewModel.getPost())
        mainView?.postBottomView.setFavouritesButton(post: viewModel.getPost())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setViewModelCallbacks() {
        viewModel.postDataLoaded = { [weak self] postData in
            self?.mainView?.postTextLabel.text = postData.text
            self?.mainView?.postImageView.getImageFor(imagePath: postData.image ?? "")
            self?.mainView?.postTitleView.avatarImageView.getImageFor(imagePath: postData.author?.avatar ?? "")
            self?.mainView?.postTitleView.nameLabel.text = postData.author?.firstName
            self?.mainView?.postTitleView.subNameLabel.text = postData.author?.lastName
            self?.mainView?.postBottomView.likeButton.setTitle("\(postData.likes)", for: .normal)
        }
        viewModel.postDidLiked = { [weak self] post in
            self?.mainView?.postBottomView.setLikeButton(post: post)
        }
        viewModel.postDidSetFavourite = { [weak self] post in
            self?.mainView?.postBottomView.setFavouritesButton(post: post)
        }
    }
    
    @objc private func postTitleDidTap(_ sender: UIView) {
        viewModel.showProfileInfo()
    }
    
    @objc private func likeButtonDidTap() {
        viewModel.likePost()
    }
    
    @objc private func favouritesButtonDidTap() {
        viewModel.setPostInFavourites()
    }
}
