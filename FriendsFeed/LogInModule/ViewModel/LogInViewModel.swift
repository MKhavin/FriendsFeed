//
//  LogInViewModel.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 04.10.2022.
//

import Foundation
import FirebaseAuth

protocol LogInViewModelProtocol {
    var coordinator: AppCoordinatorProtocol? { get set }
    var errorMessage: ((String) -> Void)? { get set }
    func logIn(with phoneNumber: String?)
}

class LogInViewModel: LogInViewModelProtocol {
    var coordinator: AppCoordinatorProtocol?
    var errorMessage: ((String) -> Void)?
    
    init(coordinator: AppCoordinatorProtocol?) {
        self.coordinator = coordinator
    }
    
    func logIn(with phoneNumber: String?) {
        guard let number = phoneNumber else {
            errorMessage?("Phone number must be set")
            return
        }
        
        PhoneAuthProvider.provider().verifyPhoneNumber(number,
                                                       uiDelegate: nil) {[unowned self] verificationID, error in
            guard error == nil else {
                self.errorMessage?(error!.localizedDescription)
                print(error!.localizedDescription)
                return
            }
            
            UserDefaults.standard.set(verificationID, forKey: "verificationID")
            
            self.coordinator?.pushConfirmationView(for: phoneNumber ?? "")
        }
    }
}
