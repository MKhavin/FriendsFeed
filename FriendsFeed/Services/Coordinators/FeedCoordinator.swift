//
//  FeedCoordinator.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 14.10.2022.
//

import UIKit

protocol FeedCoordinatorProtocol: NavigationCoordinatorProtocol {
    func pushPostInfoView()
}
                                        
class FeedCoordinator: FeedCoordinatorProtocol {
    var navigationController: UINavigationController
    var moduleFactory: ModuleFactoryProtocol
    
    required init(moduleFactory: ModuleFactoryProtocol, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
    }
    
    func pushInitialView() {
        let view = moduleFactory.buildFeedModule(coordinator: self)
        
        navigationController.pushViewController(view, animated: true)
        navigationController.tabBarItem.image = UIImage(systemName: "house.fill")
    }
    
    func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func pushPostInfoView() {
        
    }
}
