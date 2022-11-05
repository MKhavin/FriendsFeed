//
//  ProfileCoordinator.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 05.11.2022.
//

import UIKit

protocol ProfileCoordinatorProtocol: NavigationCoordinatorProtocol {
    func pushPostInfoView(with data: Post)
}
                                        
class ProfileCoordinator: ProfileCoordinatorProtocol {
    var navigationController: UINavigationController
    var moduleFactory: ModuleFactoryProtocol
    
    required init(moduleFactory: ModuleFactoryProtocol, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
    }
    
    func pushInitialView() {
        let view = moduleFactory.buildProfileModule(coordinator: self)
        
        navigationController.pushViewController(view, animated: true)
        navigationController.tabBarItem.image = UIImage(systemName: "person.crop.circle")
        navigationController.tabBarItem.title = "Профиль"
    }
    
    func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func pushPostInfoView(with data: Post) {
        let view = moduleFactory.buildPostInfoModule(coordinator: self, data: data)
        
        navigationController.pushViewController(view, animated: true)
    }
}
