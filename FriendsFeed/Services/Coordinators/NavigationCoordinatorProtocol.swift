import UIKit

protocol NavigationCoordinatorProtocol {
    var moduleFactory: ModuleFactoryProtocol { get }
    var navigationController: UINavigationController { get }
    init(moduleFactory: ModuleFactoryProtocol, navigationController: UINavigationController)
    func pushInitialView()
    func popToRoot()
}
