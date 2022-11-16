//
//  SMSConfirmationViewModel.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 04.10.2022.
//

import Foundation
import FirebaseAuth

protocol SMSConfirmationViewModelProtocol {
    var coordinator: AppCoordinatorProtocol? { get set }
    var phoneNumber: String { get }
    var showErrorMessage: ((String) -> Void)? { get set }
    var errorMessage: String { get set }
    func confirm(with code: String?)
}

class SMSConfirmationViewModel: SMSConfirmationViewModelProtocol {
    var coordinator: AppCoordinatorProtocol?
    private(set) var phoneNumber: String
    var errorMessage: String = "" {
        didSet {
            showErrorMessage?(errorMessage)
        }
    }
    var showErrorMessage: ((String) -> Void)?
    
    init(coordinator: AppCoordinatorProtocol?, phoneNumber: String) {
        self.coordinator = coordinator
        self.phoneNumber = phoneNumber
    }
    
    func confirm(with code: String?) {
        guard let number = code else {
            errorMessage = "Check your SMS-code"
            return
        }
        
        let verificationID = UserDefaults.standard.string(forKey: "verificationID")
        
        guard let id = verificationID else {
            errorMessage = "Check your SMS-code"
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(
          withVerificationID: id,
          verificationCode: number
        )
        
        Auth.auth().signIn(with: credential) { authResult, error in
            guard error == nil else {
                self.errorMessage = "Check your SMS-code"
                print(error!.localizedDescription)
                return
            }

            self.coordinator?.pushMainView()
        }
    }
}
