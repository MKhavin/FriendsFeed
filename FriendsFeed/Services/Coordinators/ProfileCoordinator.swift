import UIKit

// MARK: - Profile coordinator protocol
protocol ProfileCoordinatorProtocol: NavigationCoordinatorProtocol {
    func pushPostInfoView(with data: Post)
    func pushPhotosView(for user: String)
    func pushProfileView(for user: User?, isCurrentUserProfile: Bool)
    func pushAuthenticationView()
}

// MARK: - Profile coordinator implementation
final class ProfileCoordinator: ProfileCoordinatorProtocol {
    // MARK: - Properties
    var navigationController: UINavigationController
    var moduleFactory: ModuleFactoryProtocol
    var appCoordinator: AppCoordinatorProtocol?
    
    // MARK: - Life cycle
    required init(moduleFactory: ModuleFactoryProtocol, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
    }
    
    init(moduleFactory: ModuleFactoryProtocol, navigationController: UINavigationController, appCoordinator: AppCoordinatorProtocol?) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
        self.appCoordinator = appCoordinator
    }
    
    // MARK: - Basic navigation methods
    func pushInitialView() {
        pushProfileView(for: nil, isCurrentUserProfile: true)
        navigationController.tabBarItem.image = UIImage(systemName: "person.crop.circle")
        navigationController.tabBarItem.title = "Профиль"
    }
    
    func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
    
    // MARK: - Main navigation methods
    func pushPostInfoView(with data: Post) {
        let view = moduleFactory.buildPostInfoModule(coordinator: self, data: data)
        
        navigationController.pushViewController(view, animated: true)
    }
    
    func pushPhotosView(for user: String) {
        let view = moduleFactory.buildPhotoModule(coordinator: self, user: user)
        
        navigationController.pushViewController(view, animated: true)
    }
    
    func pushProfileView(for user: User?, isCurrentUserProfile: Bool) {
        let view = moduleFactory.buildProfileModule(
            coordinator: self,
            user: user,
            isCurrentUserProfile: isCurrentUserProfile
        )
        
        navigationController.pushViewController(view, animated: true)
    }
    
    func pushAuthenticationView() {
        appCoordinator?.pushInitialView()
    }
}
