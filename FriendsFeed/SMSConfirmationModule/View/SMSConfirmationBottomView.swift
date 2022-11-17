import UIKit

final class SMSConfirmationBottomView: UIView {
    // MARK: - Layout constraints
    private enum LayoutConstraints {
        static let leadgingTrailingOffset = 40
        static let topOffset = 20
        static let buttonHeight = 50
    }
    
    // MARK: - Sub methods
    private(set) lazy var registrationButton: UIButton = {
        let view = UIButton()
        
        view.setTitle("ЗАРЕГИСТРИРОВАТЬСЯ", for: .normal)
        view.backgroundColor = .label
        view.setTitleColor(UIColor.systemBackground, for: .normal)
        view.layer.cornerRadius = 20
        
        return view
    }()
    private lazy var imageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "RegistrationIcon"))
        
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        addSubviews([
            registrationButton,
            imageView
        ])
        setSubviewsLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Sub methods
    private func setSubviewsLayout() {
        registrationButton.snp.makeConstraints { make in
            make.height.equalTo(LayoutConstraints.buttonHeight)
            make.top.equalTo(safeAreaLayoutGuide).offset(LayoutConstraints.topOffset)
            make.leading.equalTo(safeAreaLayoutGuide).offset(LayoutConstraints.leadgingTrailingOffset)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(LayoutConstraints.leadgingTrailingOffset)
        }
        imageView.snp.makeConstraints { make in
            make.top.equalTo(registrationButton.snp.bottom).offset(LayoutConstraints.topOffset)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(LayoutConstraints.topOffset)
            make.leading.equalTo(safeAreaLayoutGuide).offset(LayoutConstraints.leadgingTrailingOffset)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(LayoutConstraints.leadgingTrailingOffset)
        }
    }
}
