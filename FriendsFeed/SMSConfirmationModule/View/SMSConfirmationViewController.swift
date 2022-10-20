//
//  SMSConfirmationViewController.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 04.10.2022.
//

import UIKit

class SMSConfirmationViewController: UIViewController {
    //MARK: - Sub properties
    var viewModel: SMSConfirmationViewModelProtocol! {
        didSet {
            viewModel.showErrorMessage = { message in
                let alert = UIAlertController(title: "Error occured",
                                              message: message,
                                              preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Ok",
                                           style: .default) { action in
                    self.dismiss(animated: true)
                }
                
                alert.addAction(action)
                
                self.present(alert, animated: true)
            }
        }
    }
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
        setButtonsActions()
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
    private func setButtonsActions() {
        mainView?.bottomView.registrationButton.addTarget(self,
                                                          action: #selector(registerButtonPressed(_:)),
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
    @objc private func keyboardWillShow(_ sender: NSNotification) {
        guard let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        self.view.frame.origin.y = 0 - keyboardSize.height
    }
    
    @objc private func keyboardWillHide(_ sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    @objc private func registerButtonPressed(_ sender: UIButton) {
        viewModel.confirm(with: mainView?.phoneNumberView.smsCodeTextField.text)
    }
}
