// MARK: - Authentication view model protocol
protocol AuthenticationViewModelProtocol {
    func pushLogInView()
}

// MARK: - Authentication view model implementation
final class AuthenticationViewModel: AuthenticationViewModelProtocol {
    // MARK: - Properties
    private var coordinator: AppCoordinatorProtocol?
    
    // MARK: - Life cycle
    init(coordinator: AppCoordinatorProtocol?) {
        self.coordinator = coordinator
    }
    
    // MARK: - Methods
    func pushLogInView() {
        coordinator?.pushLogInView()
    }
}
