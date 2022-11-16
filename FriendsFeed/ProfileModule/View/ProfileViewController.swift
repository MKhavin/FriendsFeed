import UIKit

class ProfileViewController: UIViewController {
    // swiftlint:disable:next implicitly_unwrapped_optional
    var viewModel: ProfileViewModelProtocol!
    // swiftlint:disable:previous implicitly_unwrapped_optional
    private weak var mainView: ProfileView?
    
    override func loadView() {
        let currentView = ProfileView(isCurrentUserProfile: viewModel.isCurrentUserProfile)
        mainView = currentView
        view = mainView
        mainView?.tableView.delegate = self
        mainView?.tableView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavigationBar()
        setViewModelCallbacks()
        viewModel.loadUserData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setViewModelCallbacks() {
        viewModel.userDataDidLoaded = { result in
            switch result {
            case .success(let profile):
                if let unwrappedData = profile {
                    self.mainView?.titleView.avatarImageView.getImageFor(imagePath: unwrappedData.avatar ?? "")
                    self.mainView?.titleView.firstNameLabel.text = unwrappedData.firstName
                    self.mainView?.titleView.workNameLabel.text = unwrappedData.lastName
                    self.mainView?.titleView.postsCountLabel.text = "\(unwrappedData.postsCount)\nкол-во постов"
                    self.mainView?.titleView.subscriptionsCountLabel.text = "\(unwrappedData.subscriptions)\nкол-во подписок"
                    self.mainView?.titleView.usersCountLabel.text = "\(unwrappedData.friends)\nкол-во друзей"
                }
            case .failure(let error):
                let alert = UIAlertController(title: "Error occured", message: error.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default) { _ in
                    self.dismiss(animated: true)
                }
                alert.addAction(action)
                self.present(alert, animated: true)
            }
        }
        viewModel.postsDataDidLoad = { error in
            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                let alert = UIAlertController(title: "Error occured", message: error!.localizedDescription, preferredStyle: .alert)
                // swiftlint:disable:previous force_unwrapping
                
                let action = UIAlertAction(title: "Ok", style: .default) { _ in
                    self.dismiss(animated: true)
                }
                alert.addAction(action)
                self.present(alert, animated: true)
                
                return
            }
            
            self.mainView?.tableView.reloadData()
        }
    }
    
    private func setNavigationBar() {
        if viewModel.isCurrentUserProfile {
            let navBarButton = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
                                               style: .plain,
                                               target: self,
                                               action: #selector(logOutButtonDidPressed(_:)))
            navigationItem.rightBarButtonItem = navBarButton
        }
    }
                                           
    @objc private func logOutButtonDidPressed(_ sender: UIBarButtonItem) {
        viewModel.logOut()
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return viewModel.getPostsCount()
        default: return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ItemsIdentifier.profilePhotosCell.rawValue,
                for: indexPath
            ) as? ProfilePhotosTableViewCell else {
                return UITableViewCell()
            }
            
            let currentUser = viewModel.getUserInfo()
            cell.loadImages(for: currentUser)
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ItemsIdentifier.profilePostsCell.rawValue,
                for: indexPath
            ) as? FeedTableViewCell else {
                return UITableViewCell()
            }
            
            let postData = viewModel.getPostData(for: indexPath.row)
            cell.setCell(data: postData)

            return cell
        default: return UITableViewCell()
        }
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            viewModel.pushPhotosView()
        case 1:
            viewModel.pushPostInfo(for: indexPath.row)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 150
        case 1: return UIScreen.main.bounds.height / 3
        default: return 0
        }
    }
}
