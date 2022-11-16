import UIKit

final class SMSConfirmationTitleView: UIView {
    // MARK: - UI elements
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .label
        
        let firstString = NSMutableAttributedString(
            string: "Подтверждение регистрации",
            attributes: [
                .foregroundColor: UIColor.orange,
                .font: UIFont.boldSystemFont(ofSize: 20)
            ]
        )
        let secondString = NSAttributedString(
            string: "\n\nМы отправили SMS с кодом на номер",
            attributes: [.foregroundColor: UIColor.label]
        )
        firstString.append(secondString)
        
        view.attributedText = firstString
        view.textAlignment = .center
        view.numberOfLines = 0
        
        return view
    }()
    private(set) lazy var phoneNumberLabel: UILabel = {
        let view = UILabel()
        
        view.font = .systemFont(ofSize: 17, weight: .bold)
        view.textColor = .label
        view.textAlignment = .center
        
        return view
    }()
    
    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        addSubviews([
            titleLabel,
            phoneNumberLabel
        ])
        setSubviewsLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Sub methods
    private func setSubviewsLayout() {
        phoneNumberLabel.snp.makeConstraints { make in
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(phoneNumberLabel.snp.top)
            make.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
    }
}
