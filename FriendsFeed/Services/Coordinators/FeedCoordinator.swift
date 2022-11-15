import UIKit

// MARK: - FeedCoordinatorProtocol
protocol FeedCoordinatorProtocol: NavigationCoordinatorProtocol {
    var navigationController: UINavigationController { get }
    var moduleFactory: ModuleFactoryProtocol { get }
    func pushPostInfoView(with data: Post)
}
                                      
// MARK: - FeedCoordinator implementation
final class FeedCoordinator: FeedCoordinatorProtocol {
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
        let view = moduleFactory.buildFeedModule(coordinator: self)
        
        navigationController.pushViewController(view, animated: true)
        navigationController.tabBarItem.image = UIImage(systemName: "house.fill")
    }
    
    func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
    
    // MARK: - Main navigation methods
    func pushPostInfoView(with data: Post) {
        let view = moduleFactory.buildPostInfoModule(coordinator: self, data: data)
        
        navigationController.pushViewController(view, animated: true)
    }
}
