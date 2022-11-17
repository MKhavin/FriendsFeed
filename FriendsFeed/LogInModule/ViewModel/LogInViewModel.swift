// MARK: - Log in view model protocol implementation
protocol LogInViewModelProtocol {
    var errorOccured: ((String) -> Void)? { get set }
    func logIn(with phoneNumber: String?)
}

// MARK: - Log in view model implementation
final class LogInViewModel: LogInViewModelProtocol {
    // MARK: - Properties
    private var coordinator: AppCoordinatorProtocol?
    var errorOccured: ((String) -> Void)?
    var model: LogInModelManagerProtocol?
    
    // MARK: - Life cycle
    init(coordinator: AppCoordinatorProtocol?, model: LogInModelManagerProtocol?) {
        self.coordinator = coordinator
        self.model = model
        self.model?.delegate = self
    }
    
    // MARK: - Methods
    func logIn(with phoneNumber: String?) {
        guard let currentNumber = phoneNumber else {
            errorOccured?("Проверьте введенный номер телефона")
            return
        }
        
        model?.logIn(with: currentNumber)
    }
}

// MARK: - LogIn model manager delegate
extension LogInViewModel: LogInModelManagerDelegate {
    func userDidLogIn(with phoneNumber: String) {
        coordinator?.pushConfirmationView(for: phoneNumber)
    }
    
    func userLogInError(message: String) {
        errorOccured?(message)
    }
}
