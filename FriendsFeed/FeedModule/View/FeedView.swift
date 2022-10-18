//
//  FeedView.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 05.10.2022.
//

import UIKit
import SnapKit

class FeedView: UIView {
    //MARK: - UI elements
    private(set) lazy var feedTableView: UITableView = {
        let view = UITableView()
        view.register(FeedTableViewCell.self, forCellReuseIdentifier: ItemsIdentifier.feedCell.rawValue)
        view.register(FeedSectionView.self, forHeaderFooterViewReuseIdentifier: ItemsIdentifier.feedSectionHeader.rawValue)
        return view
    }()
    
    //MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        addSubview(feedTableView)
        setSubviewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Sub methods
    private func setSubviewsLayout() {
        feedTableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}
