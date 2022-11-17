import UIKit

final class SMSConfirmationView: UIView {
    // MARK: - UI elements
    private lazy var numberView: SMSConfirmationTitleView = {
        let view = SMSConfirmationTitleView()
        return view
    }()
    private(set) lazy var phoneNumberView: SMSConfirmationTextFieldView = {
        let view = SMSConfirmationTextFieldView()
        return view
    }()
    private(set) lazy var bottomView: SMSConfirmationBottomView = {
        let view = SMSConfirmationBottomView()
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
    private func setSubviewsLayout() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        
        stackView.addArrangedSubviews([
            numberView,
            phoneNumberView,
            bottomView
        ])
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    func setTitle(phoneNumber: String) {
        numberView.phoneNumberLabel.text = phoneNumber
    }
}
