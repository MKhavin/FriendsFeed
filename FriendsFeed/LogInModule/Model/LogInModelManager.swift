import FirebaseAuth

// MARK: - LogIn Model Manager Delegate
protocol LogInModelManagerDelegate: AnyObject {
    func userDidLogIn(with phoneNumber: String)
    func userLogInError(message: String)
}

// MARK: - LogIn model manager protocol
protocol LogInModelManagerProtocol {
    var delegate: LogInModelManagerDelegate? { get set }
    func logIn(with phoneNumber: String)
}

// MARK: - Log in model manager
final class LogInModelManager: LogInModelManagerProtocol {
    // MARK: - Properties
    weak var delegate: LogInModelManagerDelegate?
    
    // MARK: - Methods
    func logIn(with phoneNumber: String) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) {[ weak self ] verificationID, error in
            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                self?.delegate?.userLogInError(message: error!.localizedDescription)
                print(error!.localizedDescription)
                // swiftlint:disable:previous force_unwrapping
                return
            }
            
            UserDefaults.standard.set(verificationID, forKey: "verificationID")
            
            self?.delegate?.userDidLogIn(with: phoneNumber)
        }
    }
}
