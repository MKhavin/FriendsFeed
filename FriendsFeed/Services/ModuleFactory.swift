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
    func buildRegisterModule(coordinator: AppCoordinatorProtocol?) -> UIViewController
}

class ModuleFactory: ModuleFactoryProtocol {
    func buildAuthenticationModule(coordinator: AppCoordinatorProtocol?) -> UIViewController {
        let view = AuthenticationViewController()
        let viewModel = AuthenticationViewModel(coordinator: coordinator)
        view.viewModel = viewModel
        
        return view
    }
    
    func buildLogInModule(coordinator: AppCoordinatorProtocol?) -> UIViewController {
        let view = UIViewController()
        view.view.backgroundColor = .green
        return view
    }
    
    func buildRegisterModule(coordinator: AppCoordinatorProtocol?) -> UIViewController {
        let view = UIViewController()
        view.view.backgroundColor = .red
        return view
    }
}
