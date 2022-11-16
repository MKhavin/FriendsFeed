import FirebaseAuth

// MARK: - SMSConfirmation model manager protocol
protocol SMSConfirmationModelManagerProtocol {
    var delegate: SMSConfirmationModelManagerDelegate? { get set }
    func signIn(with verificationID: String, verificationCode: String)
}

// MARK: - SMSConfirmatiopn model manager delegate
protocol SMSConfirmationModelManagerDelegate: AnyObject {
    func errorMessageOccured(message: String)
    func userDidSignIn()
}

// MARK: - SMSConfirmation model manager implementation
final class SMSConfirmationModelManager: SMSConfirmationModelManagerProtocol {
    // MARK: - Properties
    weak var delegate: SMSConfirmationModelManagerDelegate?
    
    // MARK: - Main methods
    func signIn(with verificationID: String, verificationCode: String) {
        let credential = PhoneAuthProvider.provider().credential(
          withVerificationID: verificationID,
          verificationCode: verificationCode
        )
        
        Auth.auth().signIn(with: credential) { [ weak self ] _, error in
            guard error == nil else {
                self?.delegate?.errorMessageOccured(message: "Проверьте ваш код")
                // swiftlint:disable:next force_unwrapping
                print(error!.localizedDescription)
                // swiftlint:disable:previous force_unwrapping
                
                return
            }

            self?.delegate?.userDidSignIn()
        }
    }
}
