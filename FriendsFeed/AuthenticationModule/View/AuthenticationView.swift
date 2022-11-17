import UIKit
import SnapKit

protocol AuthenticationViewDelegate: AnyObject {
    func logInButtonPressed(_ sender: UIButton)
}

final class AuthenticationView: UIView {
    // MARK: - Layout constants
    private enum LayoutConstants {
        static let buttonInset: CGFloat = 6
        static let buttonTopInset: CGFloat = 4
        static let buttomHeight: CGFloat = 50
        static let buttonCornerRadius: CGFloat = 100
    }
    
    // MARK: - Sub properties
    weak var delegate: AuthenticationViewDelegate?
    
    // MARK: - UI Elements
    private lazy var logoImageView: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage(named: "LaunchScreenIcon")
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    private lazy var registerButton: UIButton = {
        let view = UIButton()
        
        view.backgroundColor = .label
        
        view.layer.shadowColor = UIColor.label.withAlphaComponent(0.5).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 1
        
        view.setTitle("ВОЙТИ", for: .normal)
        view.titleLabel?.font = .preferredFont(forTextStyle: .title1)
        view.titleLabel?.adjustsFontSizeToFitWidth = true
        view.titleLabel?.minimumScaleFactor = 0.2
        view.setTitleColor(UIColor.systemBackground, for: .normal)
        
        view.addTarget(
            self,
            action: #selector(logInButtonPressed(_:)),
            for: .touchUpInside
        )
        
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
    
    override func updateConstraints() {
        registerButton.snp.updateConstraints { make in
            make.leading.trailing.equalTo(layoutMarginsGuide).inset(frame.width / LayoutConstants.buttonInset)
            make.top.equalTo(safeAreaLayoutGuide.snp.centerY).offset(frame.height / LayoutConstants.buttonTopInset)
        }
        registerButton.layer.cornerRadius = frame.height / LayoutConstants.buttonCornerRadius
        
        super.updateConstraints()
    }
    
    // MARK: - Sub methods
    private func setSubviewsLayout() {
        addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(layoutMarginsGuide)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.centerY)
        }
        
        addSubview(registerButton)
        registerButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(layoutMarginsGuide).inset(frame.width / LayoutConstants.buttonInset)
            make.top.equalTo(safeAreaLayoutGuide.snp.centerY).offset(frame.height / LayoutConstants.buttonTopInset)
            make.height.equalTo(LayoutConstants.buttomHeight)
        }
    }
    
    // MARK: - Actions
    @objc private func logInButtonPressed(_ sender: UIButton) {
        delegate?.logInButtonPressed(sender)
    }
}
