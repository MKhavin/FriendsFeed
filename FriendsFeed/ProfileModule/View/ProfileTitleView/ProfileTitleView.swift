//
//  ProfileTitleView.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 20.10.2022.
//

import UIKit
import SwiftUI

class ProfileTitleView: UIView {
    //MARK: - UI Elements
    private(set) lazy var avatarImageView: CachedImageView = {
        let view = CachedImageView()
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.label.cgColor
        view.layer.cornerRadius = 30
        view.image = UIImage(named: "LaunchScreenIcon")
        
        return view
    }()
    private(set) lazy var firstNameLabel: UILabel = {
        let value = UILabel()
        value.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        value.textColor = .label
        value.text = "Michael"
        
        return value
    }()
    private(set) lazy var workNameLabel: UILabel = {
        let value = UILabel()
        value.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        value.textColor = .lightGray
        value.text = "Programmer"
        
        return value
    }()
    private(set) lazy var editProfileButton: UIButton = {
        let view = UIButton()
        view.setTitle("Редактировать", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = 4
        view.backgroundColor = UIColor(hex: 0xF69707, alpha: 1.0)
        view.layer.shadowOffset = CGSize(width: 4, height: 4)
        view.layer.shadowRadius = 4
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.7
        view.layer.cornerRadius = 10
        
        return view
    }()
    private(set) lazy var postsCountLabel: UILabel = {
        let view = ProfileTitleSubInfoLabel(with: "1440\npublications")
        
        return view
    }()
    private(set) lazy var subscriptionsCountLabel: UILabel = {
        let view = ProfileTitleSubInfoLabel(with: "500\nsubscriptions")
        
        return view
    }()
    private(set) lazy var usersCountLabel: UILabel = {
        let view = ProfileTitleSubInfoLabel(with: "1440\nfriends")
        
        return view
    }()
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        
        return view
    }()
    private lazy var newRecordButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        view.setTitle("Запись", for: .normal)
        view.setTitleColor(.label, for: .normal)
        view.tintColor = .label
        return view
    }()
    
    //MARK: - Life cycle
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(isCurrentUserProfile: Bool) {
        super.init(frame: .zero)
        
        setSubviewsVisibility(by: isCurrentUserProfile)
        addSubviews([
            avatarImageView,
            editProfileButton,
            lineView,
            newRecordButton
        ])
        setSubviewsLayout(by: isCurrentUserProfile)
    }
    
    //MARK: - Sub properties
    private func setSubviewsVisibility(by isCurrentUserProfile: Bool) {
        editProfileButton.isHidden = !isCurrentUserProfile
        newRecordButton.isHidden = !isCurrentUserProfile
    }
    
    private func setSubviewsLayout(by isCurrentUserProfile: Bool) {
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.leading.top.equalTo(layoutMarginsGuide)
        }
        
        let titleStack = UIStackView(arrangedSubviews: [
            firstNameLabel,
            workNameLabel
        ])
        addSubview(titleStack)
        
        titleStack.axis = .vertical
        titleStack.spacing = 2
        titleStack.distribution = .fillEqually
        titleStack.alignment = .leading
        titleStack.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(10)
            make.trailing.top.equalTo(layoutMarginsGuide)
            make.bottom.equalTo(avatarImageView.snp.bottom)
        }
        
        if isCurrentUserProfile {
            editProfileButton.snp.makeConstraints { make in
                make.top.equalTo(titleStack.snp.bottom).offset(50)
                make.leading.trailing.equalTo(layoutMarginsGuide)
                make.height.equalTo(50)
            }
        }
        
        let subTitleInfoStack = UIStackView(arrangedSubviews: [
            postsCountLabel,
            subscriptionsCountLabel,
            usersCountLabel
        ])
        addSubview(subTitleInfoStack)
        
        subTitleInfoStack.axis = .horizontal
        subTitleInfoStack.spacing = 25
        subTitleInfoStack.distribution = .fillEqually
        subTitleInfoStack.alignment = .center
        subTitleInfoStack.snp.makeConstraints { make in
            make.leading.trailing.equalTo(layoutMarginsGuide)
            if isCurrentUserProfile {
                make.top.equalTo(editProfileButton.snp.bottom).offset(15)
            } else {
                make.top.equalTo(titleStack.snp.bottom).offset(15)
            }
            make.height.equalTo(60)
        }
        
        lineView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(layoutMarginsGuide)
            make.top.equalTo(subTitleInfoStack.snp.bottom)
            make.height.equalTo(1)
        }
        
        if isCurrentUserProfile {
            newRecordButton.snp.makeConstraints { make in
                make.leading.trailing.bottom.equalTo(layoutMargins)
                make.top.equalTo(lineView.snp.bottom).offset(10)
            }
        }
    }
}
