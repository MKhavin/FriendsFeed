//
//  FavouritesCoordinator.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 13.11.2022.
//

import UIKit

protocol FavouritesPostsCoordinatorProtocol: NavigationCoordinatorProtocol {
    func pushPostInfoView(with data: Post)
}
                                        
class FavouritesPostsCoordinator: FavouritesPostsCoordinatorProtocol {
    var navigationController: UINavigationController
    var moduleFactory: ModuleFactoryProtocol
    
    required init(moduleFactory: ModuleFactoryProtocol, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
    }
    
    func pushInitialView() {
        navigationController.tabBarItem.title = "Сохраненные"
        navigationController.tabBarItem.image = UIImage(systemName: "heart")
        
        pushFavouritesView()
    }
    
    func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
    
    private func pushFavouritesView() {
        let view = moduleFactory.buildFavouritesPostsModule(coordinator: self)
        
        navigationController.pushViewController(view, animated: true)
    }
    
    func pushPostInfoView(with data: Post) {
        let view = moduleFactory.buildPostInfoModule(coordinator: self, data: data)
        
        navigationController.pushViewController(view, animated: true)
    }
}
