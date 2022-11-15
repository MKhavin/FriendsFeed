import UIKit

// MARK: - App coordinator protocol
protocol AppCoordinatorProtocol: NavigationCoordinatorProtocol {
    func pushAuthenticationView()
    func pushLogInView()
    func pushConfirmationView(for phone: String)
    func pushMainView()
}

// MARK: - AppCoordinator implementation
final class AppCoordinator: AppCoordinatorProtocol {
    // MARK: - Properties
    private(set) var navigationController: UINavigationController
    private(set) var moduleFactory: ModuleFactoryProtocol
    
    // MARK: - Life cycle
    required init(moduleFactory: ModuleFactoryProtocol, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
    }
    
    // MARK: - Basic navigation methods
    func pushInitialView() {
        pushAuthenticationView()
    }
    
    func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
    
    // MARK: - Main navigation methods
    func pushAuthenticationView() {
        let view = moduleFactory.buildAuthenticationModule(coordinator: self)
        navigationController.pushViewController(view, animated: true)
    }
    
    func pushLogInView() {
        let view = moduleFactory.buildLogInModule(coordinator: self)
        navigationController.pushViewController(view, animated: true)
    }
    
    func pushConfirmationView(for phone: String) {
        let view = moduleFactory.buildSMSConfirmationModule(coordinator: self, phoneNumber: phone)
        navigationController.pushViewController(view, animated: true)
    }
    
    func pushMainView() {
        let view = moduleFactory.buildMainView()
        navigationController.setViewControllers([view], animated: true)
//        navigationController.pushViewController(view, animated: true)
    }
}
