//
//  AppCoordinator.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 16.09.2022.
//

import UIKit

protocol AppCoordinatorProtocol: NavigationCoordinatorProtocol {
    func pushAuthenticationView()
    func pushLogInView()
    func pushConfirmationView()
    func pushMainView()
}

class AppCoordinator: AppCoordinatorProtocol {
    private(set) var navigationController: UINavigationController
    private(set) var moduleFactory: ModuleFactoryProtocol
    
    required init(moduleFactory: ModuleFactoryProtocol, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
    }
    
    func pushInitialView() {
        pushAuthenticationView()
    }
    
    func pushAuthenticationView() {
        let view = moduleFactory.buildAuthenticationModule(coordinator: self)
        navigationController.pushViewController(view, animated: true)
    }
    
    func pushLogInView() {
        let view = moduleFactory.buildLogInModule(coordinator: self)
        navigationController.pushViewController(view, animated: true)
    }
    
    func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func pushConfirmationView() {
        let view = moduleFactory.buildSMSConfirmationModule(coordinator: self)
        navigationController.pushViewController(view, animated: true)
    }
    
    func pushMainView() {
        let view = moduleFactory.buildMainView()
        navigationController.setViewControllers([view], animated: true)
//        navigationController.pushViewController(view, animated: true)
    }
}

