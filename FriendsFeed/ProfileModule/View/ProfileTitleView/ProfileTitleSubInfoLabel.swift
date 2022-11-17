import UIKit

class ProfileTitleSubInfoLabel: UILabel {
    // MARK: - Life cycle
    init(with text: String?) {
        super.init(frame: .zero)
        
        font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textColor = .label
        numberOfLines = 2
        textAlignment = .center
        self.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
