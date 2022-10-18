//
//  MainTabBarControllerViewController.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 14.10.2022.
//

import UIKit

class MainTabBarControllerViewController: UITabBarController {
    //MARK: - Life cycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        navigationController?.isNavigationBarHidden = true
        tabBar.tintColor = .orange
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.viewControllers?.forEach({
            $0.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 12, weight: .regular)], for: .normal)
        })
        selectedIndex = 0
    }
}
