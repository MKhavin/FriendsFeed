import UIKit

// MARK: - LogIn view delegate protocol
protocol LogInViewDelegate: AnyObject {
    func logInButtonDidTapped(with phoneNumber: String?)
}

// MARK: - LogIn view implementation
class LogInView: UIView {
    // MARK: - Sub properties
    weak var delegate: LogInViewDelegate?
    
    // MARK: - UI Elements
    private lazy var topView: UIView = {
        let view = UIView()
        
        view.backgroundColor = nil
        view.addSubviews([
            titleLabel,
            subtitleLabel,
            numberTextField
        ])
        
        return view
    }()
    private lazy var bottomView: UIView = {
        let view = UIView()
        
        view.backgroundColor = nil
        view.addSubviews([
            logInButton,
            privacyLabel
        ])
        
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        
        view.text = "Введите номер"
        view.textColor = .label
        view.font = .systemFont(ofSize: 20, weight: .semibold)
        view.textAlignment = .center
        
        return view
    }()
    private lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        
        view.textColor = .label
        view.numberOfLines = 0
        view.text = "Введите номер телефона для входа в приложение"
        view.font = .preferredFont(forTextStyle: .title3).withSize(12)
        view.textAlignment = .center
        view.textColor = .placeholderText
        
        return view
    }()
    private lazy var numberTextField: UITextField = {
        let view = UITextField()
        
        view.placeholder = "+7__________"
        view.keyboardType = .phonePad
        view.textColor = .systemBackground
        view.backgroundColor = .label
        view.textAlignment = .center
        
        view.layer.borderColor = UIColor.label.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        
        return view
    }()
    private lazy var logInButton: UIButton = {
       let view = UIButton()
        
        view.setTitle("ДАЛЕЕ", for: .normal)
        view.backgroundColor = .label
        view.setTitleColor(UIColor.systemBackground, for: .normal)
        view.layer.cornerRadius = 5
        
        view.addTarget(
            self,
            action: #selector(logInButtonPressed(_:)),
            for: .touchUpInside
        )
        
        return view
    }()
    private lazy var privacyLabel: UILabel = {
        let view = UILabel()
        
        view.numberOfLines = 3
        view.text = "Нажимая кнопку “Далее” Вы принимаете пользовательское Соглашение и политику конфедициальности"
        view.textAlignment = .center
        view.textColor = .placeholderText
        view.font = .systemFont(ofSize: 12)
        
        return view
    }()
    
    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        setSubviewsLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Sub methods
    private func getStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [
            topView,
            bottomView
        ])
        
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.axis = .vertical
        
        return stackView
    }
    
    private func setTopViewSubviewsLayout() {
        numberTextField.snp.makeConstraints { make in
            make.bottom.equalTo(topView.layoutMarginsGuide).inset(-20)
            make.leading.trailing.equalTo(topView.layoutMarginsGuide).inset(30)
            make.height.equalTo(50)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(numberTextField.snp.top).inset(-15)
            make.leading.trailing.equalTo(topView.layoutMarginsGuide).inset(80)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(subtitleLabel.snp.top).inset(-2)
            make.leading.trailing.equalTo(topView.layoutMarginsGuide).inset(80)
        }
    }
    
    private func setBottomViewSubviewsLayout() {
        logInButton.snp.makeConstraints { make in
            make.top.equalTo(bottomView.layoutMarginsGuide).offset(60)
            make.leading.trailing.equalTo(bottomView.layoutMarginsGuide).inset(80)
        }
        
        privacyLabel.snp.makeConstraints { make in
            make.top.equalTo(logInButton.snp.bottom).offset(10)
            make.leading.trailing.equalTo(bottomView.layoutMarginsGuide).inset(30)
        }
    }
    
    private func setSubviewsLayout() {
        setTopViewSubviewsLayout()
        setBottomViewSubviewsLayout()
        
        let stackView = getStackView()
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(layoutMarginsGuide)
        }
    }
    
    // MARK: - Actions
    @objc private func logInButtonPressed(_ sender: UIButton) {
        delegate?.logInButtonDidTapped(with: numberTextField.text)
    }
}
