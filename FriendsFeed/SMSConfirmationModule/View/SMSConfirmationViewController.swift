//
//  SMSConfirmationViewController.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 04.10.2022.
//

import UIKit

class SMSConfirmationViewController: UIViewController {
    //MARK: - Sub properties
    var viewModel: String!
    private weak var mainView: SMSConfirmationView?
    
    //MARK: - Life cycle
    override func loadView() {
        let subView = SMSConfirmationView()
        view = subView
        mainView = subView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

}
