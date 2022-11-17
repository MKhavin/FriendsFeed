import UIKit

final class SMSConfirmationTextFieldView: UIView {
    // MARK: - Layout constraints
    private enum LayoutConstraints {
        static let leadingTrailingInset = 40
        static let textFieldHeight = 50
        static let titleInset = 10
    }
    
    // MARK: - UI elements
    private lazy var smsTitleLabel: UILabel = {
        let view = UILabel()
        
        view.text = "Введите код из SMS"
        view.textColor = .lightGray
        view.textAlignment = .left
        
        return view
    }()
    private(set) lazy var smsCodeTextField: UITextField = {
        let view = UITextField()
        
        view.placeholder = "------"
        view.backgroundColor = .label
        view.textColor = .systemBackground
        view.textAlignment = .center
        view.keyboardType = .numberPad
        
        view.layer.cornerRadius = 20
        view.layer.borderColor = UIColor.label.cgColor
        view.layer.borderWidth = 1
        
        return view
    }()
    
    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        addSubviews([
            smsTitleLabel,
            smsCodeTextField
        ])
        
        setSubviewsLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Sub methods
    private func setSubviewsLayout() {
        smsCodeTextField.snp.makeConstraints { make in
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(safeAreaLayoutGuide).offset(LayoutConstraints.leadingTrailingInset)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(LayoutConstraints.leadingTrailingInset)
            make.height.equalTo(LayoutConstraints.textFieldHeight)
        }
        
        smsTitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(smsCodeTextField.snp.top).inset(-LayoutConstraints.titleInset)
            make.leading.equalTo(safeAreaLayoutGuide).offset(LayoutConstraints.leadingTrailingInset)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(LayoutConstraints.leadingTrailingInset)
        }
    }
}
