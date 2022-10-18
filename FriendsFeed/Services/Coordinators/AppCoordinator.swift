//
//  AppCoordinator.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 16.09.2022.
//

import UIKit

protocol AppCoordinatorProtocol: NavigationCoordinatorProtocol {
    func pushAuthenticationView()
    func pushRegisterView()
    func pushLogInView()
    func pushMainView()
}

class AppCoordinator: AppCoordinatorProtocol {
    private var navigationController: UINavigationController
    private var moduleFactory: ModuleFactoryProtocol
    
    required init(moduleFactory: ModuleFactoryProtocol, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
    }
    
    func pushInitialView() {
        //        pushAuthenticationView()
        pushMainView()
    }
    
    func pushAuthenticationView() {
        let view = moduleFactory.buildAuthenticationModule(coordinator: self)
        navigationController.pushViewController(view, animated: true)
    }
    
    func pushRegisterView() {
        let view = moduleFactory.buildRegisterModule(coordinator: self)
        navigationController.pushViewController(view, animated: true)
    }
    
    func pushLogInView() {
        let view = moduleFactory.buildLogInModule(coordinator: self)
        navigationController.pushViewController(view, animated: true)
    }
    
    func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func pushMainView() {
        let view = moduleFactory.buildMainView()
        
        navigationController.pushViewController(view, animated: true)
    }
}

