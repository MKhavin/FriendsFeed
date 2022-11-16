import UIKit

// MARK: - Favourites coordinator protocol
protocol FavouritesCoordinatorProtocol: NavigationCoordinatorProtocol {
    func pushPostInfoView(with data: Post)
}
           
// MARK: - Favourites coordinator implementation
final class FavouritesCoordinator: FavouritesCoordinatorProtocol {
    // MARK: - Properties
    var navigationController: UINavigationController
    var moduleFactory: ModuleFactoryProtocol
    
    // MARK: - Life cycle
    required init(moduleFactory: ModuleFactoryProtocol, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
    }
    
    // MARK: - Basic navigation methods
    func pushInitialView() {
        navigationController.tabBarItem.title = "Сохраненные"
        navigationController.tabBarItem.image = UIImage(systemName: "heart")
        
        pushFavouritesView()
    }
    
    func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
    
    // MARK: - Main navigation methods
    private func pushFavouritesView() {
        let view = moduleFactory.buildFavouritesPostsModule(coordinator: self)
        
        navigationController.pushViewController(view, animated: true)
    }
    
    func pushPostInfoView(with data: Post) {
        let view = moduleFactory.buildPostInfoModule(coordinator: self, data: data)
        
        navigationController.pushViewController(view, animated: true)
    }
}
