//
//  NavigationCoordinatorProtocol.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 18.10.2022.
//

import UIKit

protocol NavigationCoordinatorProtocol {
    init(moduleFactory: ModuleFactoryProtocol, navigationController: UINavigationController)
    func pushInitialView()
    func popToRoot()
    var moduleFactory: ModuleFactoryProtocol { get }
    var navigationController: UINavigationController { get }
}
