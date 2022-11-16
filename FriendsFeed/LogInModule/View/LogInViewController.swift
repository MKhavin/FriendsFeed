import UIKit

// MARK: - LogIn view controller implementation
class LogInViewController: UIViewController {
    // MARK: - Sub properties
    private weak var mainView: LogInView?
    // swiftlint:disable:next implicitly_unwrapped_optional
    var viewModel: LogInViewModelProtocol!
    // swiftlint:disable:previous implicitly_unwrapped_optional
    
    // MARK: - Life cycle
    override func loadView() {
        let currentView = LogInView()
        
        view = currentView
        
        mainView = currentView
        mainView?.delegate = self
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
    
    // MARK: - Sub methods
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
    
    private func swtViewModelCallbacks() {
        viewModel.errorOccured = { message in
            let alert = UIAlertController(title: "Возникла ошибка",
                                          message: message,
                                          preferredStyle: .alert)
            
            let action = UIAlertAction(
                title: "Попробовать еще раз",
                style: .default
            ) { _ in
                self.dismiss(animated: true)
            }
            
            alert.addAction(action)
            
            self.present(alert, animated: true)
        }
    }
    
    // MARK: - Actions    
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

// MARK: - LogIn view delegate implementation
extension LogInViewController: LogInViewDelegate {
    func logInButtonDidTapped(with phoneNumber: String?) {
        viewModel.logIn(with: phoneNumber)
    }
}
