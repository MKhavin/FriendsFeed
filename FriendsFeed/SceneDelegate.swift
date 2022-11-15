import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let currentScene = (scene as? UIWindowScene) else {
            return
        }
        
        window = UIWindow(windowScene: currentScene)
        
        let navigationController = UINavigationController()
        let coordinator = AppCoordinator(moduleFactory: ModuleFactory(),
                                         navigationController: navigationController)
        coordinator.pushInitialView()
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        setNavigationControllerAppearance()
    }
    
    private func setNavigationControllerAppearance() {
        UINavigationBar.appearance().backIndicatorImage = UIImage(systemName: "arrow.backward")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.backward")
        UINavigationBar.appearance().tintColor = .label
        
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: "Helvetica-Bold", size: 0.1) ?? UIFont(),
            NSAttributedString.Key.foregroundColor: UIColor.clear
        ]
        
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .highlighted)
    }
}
