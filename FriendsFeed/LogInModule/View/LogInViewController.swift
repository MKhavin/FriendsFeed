//
//  LogInViewController.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 19.09.2022.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {
    //MARK: - Sub properties
    private weak var logInView: LogInView?
    var viewModel: LogInViewModelProtocol! {
        didSet {
            viewModel.errorMessage = { message in
                let alert = UIAlertController(title: "Error occured",
                                              message: message,
                                              preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Try again",
                                           style: .default) { action in
                    self.dismiss(animated: true)
                }
                
                alert.addAction(action)
                
                self.present(alert, animated: true)
            }
        }
    }
    
    //MARK: - Life cycle
    override func loadView() {
        let currentView = LogInView()
        view = currentView
        logInView = currentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setButtonsAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
        setNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeNotifications()
    }
    
    //MARK: - Sub methods
    private func setButtonsAction() {
        logInView?.logInButton.addTarget(self,
                                         action: #selector(logInButtonPressed(_:)),
                                         for: .touchUpInside)
    }
    
    private func setNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeNotifications() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    //MARK: - Actions
    @objc private func logInButtonPressed(_ sender: UIButton) {
        viewModel.logIn(with: logInView?.numberTextField.text)
    }
    
    @objc private func keyboardWillShow(_ sender: NSNotification) {
        guard let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        self.view.frame.origin.y = 0 - keyboardSize.height
    }
    
    @objc private func keyboardWillHide(_ sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
}
