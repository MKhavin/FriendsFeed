//
//  ModuleFactory.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 16.09.2022.
//

import UIKit

protocol ModuleFactoryProtocol {
    func buildAuthenticationModule(coordinator: AppCoordinatorProtocol?) -> UIViewController
    func buildLogInModule(coordinator: AppCoordinatorProtocol?) -> UIViewController
//    func buildRegisterModule(coordinator: AppCoordinatorProtocol?) -> UIViewController
    func buildFeedModule(coordinator: FeedCoordinatorProtocol?) -> UIViewController
    func buildMainView() -> UIViewController
    func buildPostInfoModule(coordinator: FeedCoordinatorProtocol?, data: Post) -> UIViewController
    func buildSMSConfirmationModule(coordinator: AppCoordinatorProtocol?) -> UIViewController
}

class ModuleFactory: ModuleFactoryProtocol {
    func buildSMSConfirmationModule(coordinator: AppCoordinatorProtocol?) -> UIViewController {
        let view = SMSConfirmationViewController()
        let viewModel = SMSConfirmationViewModel(coordinator: coordinator)
        view.viewModel = viewModel
        
        return view
    }
        
    func buildPostInfoModule(coordinator: FeedCoordinatorProtocol?, data: Post) -> UIViewController {
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
        let view = LogInViewController()
        let viewModel = LogInViewModel(coordinator: coordinator)
        view.viewModel = viewModel
        
        return view
    }
    
    func buildMainView() -> UIViewController {
        let tabBarController = MainTabBarControllerViewController()
        
        let feedNavigationController = UINavigationController()
        let feedCoordinator = FeedCoordinator(moduleFactory: self, navigationController: feedNavigationController)
        feedCoordinator.pushInitialView()
        
        // Temporary
        let profileView = UIViewController()
        profileView.title = "Профиль"
        profileView.tabBarItem.image = UIImage(systemName: "person.crop.circle")
        
        let favouritesView = UIViewController()
        favouritesView.title = "Сохраненные"
        favouritesView.tabBarItem.image = UIImage(systemName: "heart")
        //
        
        tabBarController.setViewControllers([
            feedNavigationController,
            profileView,
            favouritesView
        ],
                                            animated: false)
        
        return tabBarController
    }
}
