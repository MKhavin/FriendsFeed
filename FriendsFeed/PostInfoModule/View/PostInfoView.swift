import UIKit
import SwiftUI

class PostInfoView: UIScrollView {
    // MARK: - UI elements
    private(set) lazy var postTextLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        
        return view
    }()
    private(set) lazy var postImageView: CachedImageView = {
        let view = CachedImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        
        return view
    }()
    private(set) lazy var postTitleView: PostInfoTitleView = {
        let view = PostInfoTitleView()
        
        return view
    }()
    private(set) lazy var postBottomView: LikeFavouritesBottomView = {
        let view = LikeFavouritesBottomView()
        
        return view
    }()
    private lazy var contentView: UIView = {
        let view = UIView()
        view.addSubviews([
            postTitleView,
            postImageView,
            postTextLabel,
            postBottomView
        ])
        
        return view
    }()
    
    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        bounces = true
        
        addSubview(contentView)
        setSubviewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Sub methods
    private func setSubviewsLayout() {
        contentView.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalTo(contentLayoutGuide)
            make.width.equalTo(frameLayoutGuide)
        }
        
        postTitleView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView.layoutMarginsGuide)
            make.height.equalTo(35)
        }

        postImageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView.layoutMarginsGuide)
            make.height.equalTo(250)
            make.top.equalTo(postTitleView.snp.bottom).offset(10)
        }
        
        postTextLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(contentView.layoutMarginsGuide)
            make.top.equalTo(postImageView.snp.bottom).offset(10)
        }
        
        postBottomView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(contentView.layoutMarginsGuide)
            make.top.equalTo(postTextLabel.snp.bottom).offset(10)
        }
    }
}
