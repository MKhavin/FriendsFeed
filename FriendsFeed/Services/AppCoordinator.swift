//
//  AppCoordinator.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 16.09.2022.
//

import UIKit

protocol AppCoordinatorProtocol {
    init(moduleFactory: ModuleFactoryProtocol, navigationController: UINavigationController)
    func pushInitialView()
    func pushAuthenticationView()
    func pushRegisterView()
    func pushLogInView()
    func popToRoot()
}

class AppCoordinator: AppCoordinatorProtocol {
    private var navigationController: UINavigationController
    private var moduleFactory: ModuleFactoryProtocol
    
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
}

