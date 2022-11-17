import UIKit

// MARK: - Authentication view controller
final class AuthenticationViewController: UIViewController {
    // MARK: - Sub properties
    private weak var mainView: AuthenticationView?
    // swiftlint:disable:next implicitly_unwrapped_optional
    var viewModel: AuthenticationViewModelProtocol!
    // swiftlint:disable:previous implicitly_unwrapped_optional
    
    // MARK: - Life cycle
    override func loadView() {
        let newView = AuthenticationView()
        
        view = newView
        
        mainView = newView
        mainView?.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - Implementation of AuthenticationViewDelegate
extension AuthenticationViewController: AuthenticationViewDelegate {
    func logInButtonPressed(_ sender: UIButton) {
        viewModel.pushLogInView()
    }
}
