//
//  AuthenticationViewController.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 15.09.2022.
//

import UIKit

class AuthenticationViewController: UIViewController {
    //MARK: - Sub properties
    private weak var authenticationView: AuthenticationView?
    var viewModel: AuthenticationViewModelProtocol!
    
    //MARK: - Life cycle
    override func loadView() {
        let newView = AuthenticationView()
        view = newView
        authenticationView = newView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setButtonsActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: - Sub methods
    private func setButtonsActions() {
        authenticationView?.logInButton.addTarget(self,
                                                  action: #selector(logInButtonPressed(_:)),
                                                  for: .touchUpInside)
        
        authenticationView?.registerButton.addTarget(self,
                                                  action: #selector(registerButtonPressed(_:)),
                                                  for: .touchUpInside)
    }
    
    //MARK: - Actions
    @objc private func registerButtonPressed(_ sender: UIButton) {
        viewModel.pushRegisterView()
    }
    
    @objc private func logInButtonPressed(_ sender: UIButton) {
        viewModel.pushLogInView()
    }
}
