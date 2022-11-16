import UIKit
import SwiftUI
import SnapKit

class FeedSectionView: UITableViewHeaderFooterView {
    // MARK: - UI elements
    private(set) lazy var dateLabel: UILabelWithPadding = {
        let view = UILabelWithPadding()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.label.cgColor
        view.layer.cornerRadius = 15
        
        return view
    }()
    
    // MARK: - Life cycle
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .systemBackground
        addSubview(dateLabel)
        setSubviewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Sub methods
    private func setSubviewsLayout() {
        let leftBorder = UIView(frame: .zero)
        let rightBorder = UIView(frame: .zero)
        
        leftBorder.backgroundColor = .label
        rightBorder.backgroundColor = .label
        
        addSubviews([
            leftBorder,
            rightBorder
        ])
        
        dateLabel.snp.makeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
        }
        
        leftBorder.snp.makeConstraints { make in
            make.leading.centerY.equalTo(safeAreaLayoutGuide)
            make.trailing.equalTo(dateLabel.snp.leading).inset(-10)
            make.height.equalTo(2)
        }
        
        rightBorder.snp.makeConstraints { make in
            make.trailing.centerY.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(dateLabel.snp.trailing).offset(10)
            make.height.equalTo(2)
        }
    }
    
    func setCell(data: Date) {
        dateLabel.text = data.formatted(by: "d MMMM")
    }
}
