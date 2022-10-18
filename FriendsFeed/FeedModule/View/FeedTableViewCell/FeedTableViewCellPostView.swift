//
//  FeedTableViewCellPostView.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 10.10.2022.
//

import UIKit

class FeedTableViewCellPostView: UIView {
    //MARK: - UI elements
    private(set) lazy var postTextLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 4
        view.text = "Test post"
        
        return view
    }()
    private(set) lazy var postImageView: CachedImageView = {
        let view = CachedImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .systemBackground
        view.clipsToBounds = true
        
        return view
    }()
    private lazy var leftBorder: UIView = {
        let view = UIView()
        view.backgroundColor = .label
        
        return view
    }()
    
    //MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews([
            leftBorder,
            postTextLabel,
            postImageView
        ])
        setSubviewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Sub methods
    private func setSubviewsLayout() {
        leftBorder.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).offset(10)
            make.top.bottom.equalTo(layoutMarginsGuide)
            make.width.equalTo(2)
        }
        
        postTextLabel.snp.makeConstraints { make in
            make.top.trailing.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(leftBorder.snp.trailing).offset(5)
            make.bottom.equalTo(snp.centerY).inset(-2)
        }
        
        postImageView.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(layoutMarginsGuide)
            make.top.equalTo(snp.centerY).offset(2)
            make.leading.equalTo(postTextLabel)
        }
    }
}
