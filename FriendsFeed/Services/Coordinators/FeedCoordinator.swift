//
//  FeedCoordinator.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 14.10.2022.
//

import UIKit

protocol FeedCoordinatorProtocol: NavigationCoordinatorProtocol {
    func pushPostInfoView(with data: Post)
    var navigationController: UINavigationController { get }
    var moduleFactory: ModuleFactoryProtocol { get }
}
                                        
class FeedCoordinator: FeedCoordinatorProtocol {
    private(set) var navigationController: UINavigationController
    private(set) var moduleFactory: ModuleFactoryProtocol
    
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
    
    func pushPostInfoView(with data: Post) {
        let view = moduleFactory.buildPostInfoModule(coordinator: self, data: data)
        
        navigationController.pushViewController(view, animated: true)
    }
}
