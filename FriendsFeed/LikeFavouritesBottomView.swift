//
//  FeedTableViewCellBottomView.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 10.10.2022.
//

import UIKit

class LikeFavouritesBottomView: UIView {
    //MARK: - UI elements
    private(set) lazy var likeButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "heart"), for: .normal)
        view.setTitle("Like", for: .normal)
        view.tintColor = .label
        view.setTitleColor(UIColor.label, for: .normal)
        
        return view
    }()
    private(set) lazy var favouritesButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "bookmark.square"), for: .normal)
        view.tintColor = .label
        view.setTitle("Favourite", for: .normal)
        view.setTitleColor(UIColor.label, for: .normal)
        
        return view
    }()
    private lazy var topBorder: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        
        return view
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        
        stackView.addArrangedSubview(likeButton)
        stackView.addArrangedSubview(favouritesButton)
        
        return stackView
    }()
    
    //MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews([
            topBorder,
            stackView
        ])
        
        setSubviewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Sub methods
    private func setSubviewsLayout() {
        topBorder.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(topBorder.snp.bottom).offset(10)
        }
    }
}
