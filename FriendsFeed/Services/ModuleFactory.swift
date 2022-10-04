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
    func buildSMSConfirmationModule(coordinator: AppCoordinatorProtocol?) -> UIViewController
}

class ModuleFactory: ModuleFactoryProtocol {
    func buildSMSConfirmationModule(coordinator: AppCoordinatorProtocol?) -> UIViewController {
        let view = SMSConfirmationViewController()
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
}
