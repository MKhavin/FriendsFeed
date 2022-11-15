import UIKit

// MARK: - Module factory protocol
protocol ModuleFactoryProtocol {
    func buildAuthenticationModule(coordinator: AppCoordinatorProtocol?) -> UIViewController
    func buildLogInModule(coordinator: AppCoordinatorProtocol?) -> UIViewController
    func buildFeedModule(coordinator: FeedCoordinatorProtocol?) -> UIViewController
    func buildMainView() -> UIViewController
    func buildPostInfoModule(coordinator: NavigationCoordinatorProtocol?, data: Post) -> UIViewController
    func buildSMSConfirmationModule(coordinator: AppCoordinatorProtocol?, phoneNumber: String) -> UIViewController
    func buildProfileModule(coordinator: ProfileCoordinatorProtocol?, user: User?, isCurrentUserProfile: Bool) -> UIViewController
    func buildPhotoModule(coordinator: NavigationCoordinatorProtocol?, user: String) -> UIViewController
    func buildFavouritesPostsModule(coordinator: FavouritesCoordinatorProtocol?) -> UIViewController
}

// MARK: - Module factory implementation
final class ModuleFactory: ModuleFactoryProtocol {
    func buildSMSConfirmationModule(coordinator: AppCoordinatorProtocol?, phoneNumber: String) -> UIViewController {
        let view = SMSConfirmationViewController()
        let viewModel = SMSConfirmationViewModel(coordinator: coordinator, phoneNumber: phoneNumber)
        view.viewModel = viewModel
        
        return view
    }
        
    func buildPostInfoModule(coordinator: NavigationCoordinatorProtocol?, data: Post) -> UIViewController {
        let view = PostInfoViewController()
        let viewModel = PostInfoViewModel(coordinator: coordinator, data: data)
        view.viewModel = viewModel
        
        return view
    }
    
    func buildFeedModule(coordinator: FeedCoordinatorProtocol?) -> UIViewController {
        let view = FeedViewController()
        let viewModel = FeedViewModel(coordinator: coordinator)
        view.viewModel = viewModel
        
        return view
    }
    
    func buildAuthenticationModule(coordinator: AppCoordinatorProtocol?) -> UIViewController {
        let view = AuthenticationViewController()
        let viewModel = AuthenticationViewModel(coordinator: coordinator)
        view.viewModel = viewModel
        
        return view
    }
    
    func buildLogInModule(coordinator: AppCoordinatorProtocol?) -> UIViewController {
        let model = LogInModelManager()
        let view = LogInViewController()
        let viewModel = LogInViewModel(coordinator: coordinator, model: model)
        view.viewModel = viewModel
        
        return view
    }
    
    func buildMainView() -> UIViewController {
        let tabBarController = MainTabBarControllerViewController()
        
        let feedNavigationController = UINavigationController()
        let feedCoordinator = FeedCoordinator(moduleFactory: self,
                                              navigationController: feedNavigationController)
        feedCoordinator.pushInitialView()
        
        let profileNavigationController = UINavigationController()
        let profileCoordinator = ProfileCoordinator(moduleFactory: self,
                                                    navigationController: profileNavigationController)
        profileCoordinator.pushInitialView()
        
        let favouritesPostsNavigationController = UINavigationController()
        let favouritesPostsCoordinator = FavouritesCoordinator(moduleFactory: self,
                                                                    navigationController: favouritesPostsNavigationController)
        favouritesPostsCoordinator.pushInitialView()

        tabBarController.setViewControllers(
            [
                feedNavigationController,
                profileNavigationController,
                favouritesPostsNavigationController
            ],
            animated: false
        )
        
        return tabBarController
    }
    
    func buildProfileModule(coordinator: ProfileCoordinatorProtocol?, user: User?, isCurrentUserProfile: Bool) -> UIViewController {
        let model = ProfileModelManager(profile: user)
        let view = ProfileViewController()
        let viewModel = ProfileViewModel(model: model, coordinator: coordinator, isCurrentProfile: isCurrentUserProfile)
        view.viewModel = viewModel
        if isCurrentUserProfile {
            view.title = "Профиль"
        }
        
        return view
    }
    
    func buildPhotoModule(coordinator: NavigationCoordinatorProtocol?, user: String) -> UIViewController {
        let view = PhotosViewController()
        let viewModel = PhotosViewModel(coordinator: coordinator, user: user)
        view.viewModel = viewModel
        
        return view
    }
    
    func buildFavouritesPostsModule(coordinator: FavouritesCoordinatorProtocol?) -> UIViewController {
        let view = FavouritesViewController()
        let model = FavouritesModelManager()
        let viewModel = FavouritesViewModel(model: model, coordinator: coordinator)
        view.viewModel = viewModel
        
        return view
    }
}
