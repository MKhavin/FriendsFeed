//
//  FeedTableViewCell.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 05.10.2022.
//

import UIKit
import SwiftUI
import SnapKit

class FeedTableViewCell: UITableViewCell {
    //MARK: - UI elements
    private lazy var titleView = FeedTableViewCellTitleView()
    private lazy var postView: FeedTableViewCellPostView = FeedTableViewCellPostView()
    private(set) lazy var bottomView: LikeFavouritesBottomView = LikeFavouritesBottomView()
    
    //MARK: - Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setSubviewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Set titleView data
        titleView.nameLabel.text = ""
        titleView.subNameLabel.text = ""
        titleView.avatarImageView.image = nil
        
        //Set postView data
        postView.postTextLabel.text = ""
        postView.postImageView.image = nil
        
        //Set bottomView data
        bottomView.likeButton.setTitle("", for: .normal)
    }
    
    //MARK: - Sub methods
    func setCell(data: Post) {
        // Set titleView data
        titleView.nameLabel.text = data.author.firstName
        titleView.subNameLabel.text = data.author.lastName
        titleView.avatarImageView.getImageFor(imagePath: data.author.avatar ?? "")
        
        //Set postView data
        postView.postTextLabel.text = data.text
        postView.postImageView.getImageFor(imagePath: data.image ?? "")
        
        //Set bottomView data
        bottomView.likeButton.setTitle("\(data.likes ?? 0)", for: .normal)
    }
    
    private func setSubviewsLayout() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.backgroundColor = UIColor(red: 245/255.0,
                                            green: 243/255.0,
                                            blue: 238/255.0,
                                            alpha: 1)
        
        stackView.addArrangedSubview(titleView)
        stackView.addArrangedSubview(postView)
        stackView.addArrangedSubview(bottomView)
        
        addSubview(stackView)
        
        titleView.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.top.bottom.equalTo(layoutMarginsGuide)
        }
        
        bottomView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
}
