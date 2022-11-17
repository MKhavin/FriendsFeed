import FirebaseAuth

// MARK: - SMSConfirmation view model protocol
protocol SMSConfirmationViewModelProtocol {
    var phoneNumber: String { get }
    var showErrorMessage: ((String) -> Void)? { get set }
    func confirm(with code: String?)
}

// MARK: - SMSConfimation view model implementation
final class SMSConfirmationViewModel: SMSConfirmationViewModelProtocol {
    // MARK: - Properties
    private var coordinator: AppCoordinatorProtocol?
    private var model: SMSConfirmationModelManagerProtocol?
    private(set) var phoneNumber: String
    var showErrorMessage: ((String) -> Void)?
    
    // MARK: - Life cycle
    init(coordinator: AppCoordinatorProtocol?, model: SMSConfirmationModelManagerProtocol?, phoneNumber: String) {
        self.coordinator = coordinator
        self.phoneNumber = phoneNumber
        
        self.model = model
        self.model?.delegate = self
    }
    
    // MARK: - Main methods
    func confirm(with code: String?) {
        guard let value = code else {
            showErrorMessage?("Проверьте код в SMS-сообщении.")
            return
        }
        
        let verificationID = UserDefaults.standard.string(forKey: "verificationID")
        
        guard let id = verificationID else {
            showErrorMessage?("Вернитесь на предыдущий экран и попробуйте войти снова.")
            return
        }
        
        model?.signIn(with: id, verificationCode: value)
    }
}

// MARK: - SMSConfirmation model manager delegate implementation
extension SMSConfirmationViewModel: SMSConfirmationModelManagerDelegate {
    func errorMessageOccured(message: String) {
        showErrorMessage?(message)
    }
    
    func userDidSignIn() {
        coordinator?.pushMainView()
    }
}
