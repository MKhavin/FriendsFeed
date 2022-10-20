//
//  MainTabBarControllerViewController.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 14.10.2022.
//

import UIKit

class MainTabBarControllerViewController: UITabBarController {
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viewControllers?.forEach({
            $0.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12, weight: .regular)], for: .normal)
        })
        selectedIndex = 0
        tabBar.tintColor = .orange
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
}
