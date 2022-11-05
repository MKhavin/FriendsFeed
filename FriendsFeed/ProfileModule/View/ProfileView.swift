//
//  ProfileView.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 20.10.2022.
//

import UIKit
import SwiftUI

class ProfileView: UIView {
    //MARK: - UI elemens
    private(set) lazy var titleView = ProfileTitleView()
    private(set) lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(FeedTableViewCell.self, forCellReuseIdentifier: ItemsIdentifier.profilePostsCell.rawValue)
        view.register(ProfilePhotosTableViewCell.self, forCellReuseIdentifier: ItemsIdentifier.profilePhotosCell.rawValue)
//        view.dataSource = self
//        view.delegate = self
//
        return view
    }()
    
    //MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        addSubviews([
            titleView,
            tableView
        ])
        setSubviewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        titleView.snp.updateConstraints { make in
            make.height.equalTo(frame.height / 3)
        }
        
        super.updateConstraints()
    }
    
    //MARK: - Sub methods
    private func setSubviewsLayout() {
        titleView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(frame.height / 3)
        }
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(titleView.snp.bottom).offset(1)
        }
    }
}
