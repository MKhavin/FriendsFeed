import UIKit
import SwiftUI

class ProfileView: UIView {
    // MARK: - UI elemens
    private(set) var titleView: ProfileTitleView
    private(set) lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(FeedTableViewCell.self, forCellReuseIdentifier: ItemsIdentifier.profilePostsCell.rawValue)
        view.register(ProfilePhotosTableViewCell.self, forCellReuseIdentifier: ItemsIdentifier.profilePhotosCell.rawValue)

        return view
    }()
    private let isCurrentUserProfile: Bool
    
    // MARK: - Life cycle
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(isCurrentUserProfile: Bool) {
        self.isCurrentUserProfile = isCurrentUserProfile
        titleView = ProfileTitleView(isCurrentUserProfile: isCurrentUserProfile)
        super.init(frame: .zero)
        
        backgroundColor = .systemBackground
        addSubviews([
            titleView,
            tableView
        ])
        setSubviewsLayout()
    }
    
    override func updateConstraints() {
        titleView.snp.updateConstraints { make in
//            let multiplier: CGFloat = isCurrentUserProfile ? 3 : 5
            make.height.equalTo(frame.height / 5)
        }
        
        super.updateConstraints()
    }
    
    // MARK: - Sub methods
    private func setSubviewsLayout() {
        titleView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(safeAreaLayoutGuide)
//            let multiplier: CGFloat = isCurrentUserProfile ? 3 : 5
            make.height.equalTo(frame.height / 5)
        }
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(titleView.snp.bottom).offset(1)
        }
    }
}
