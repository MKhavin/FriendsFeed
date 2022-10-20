//
//  PostInfoTitleView.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 19.10.2022.
//

import UIKit

class PostInfoTitleView: UIView {
    //MARK: - UI elements
    private(set) lazy var avatarImageView: CachedImageView = {
        let view = CachedImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.label.cgColor
        view.layer.borderWidth = 1
        
        return view
    }()
    private(set) lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        
        return view
    }()
    private(set) lazy var subNameLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12)
        view.textColor = .lightGray
        
        return view
    }()
    
    //MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        addSubviews([
            avatarImageView,
            nameLabel,
            subNameLabel
        ])
        
        setSubviewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Sub methods
    private func setSubviewsLayout() {
        avatarImageView.snp.makeConstraints { make in
            make.leading.equalTo(layoutMarginsGuide)
            make.width.height.equalTo(30)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.trailing.equalTo(layoutMarginsGuide)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(15)
            make.top.equalTo(avatarImageView)
        }
        
        subNameLabel.snp.makeConstraints { make in
            make.trailing.equalTo(layoutMarginsGuide)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(15)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.bottom.equalTo(avatarImageView)
        }
    }
}
