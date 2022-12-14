import UIKit

class LikeFavouritesBottomView: UIView {
    // MARK: - UI elements
    private(set) lazy var likeButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "heart"), for: .normal)
        view.setTitle("Лайки", for: .normal)
        view.tintColor = .label
        view.setTitleColor(UIColor.label, for: .normal)
        
        return view
    }()
    private(set) lazy var favouritesButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "bookmark"), for: .normal)
        view.tintColor = .gray
        view.setTitle("Избранное", for: .normal)
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
    
    // MARK: - Life cycle
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
    
    // MARK: - Sub methods
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
    
    func setLikeButton(post: Post?) {
        guard let currentPost = post else {
            return
        }
        
        likeButton.setTitle("\(currentPost.likes)", for: .normal)
        if currentPost.isLiked {
            likeButton.tintColor = .red
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeButton.tintColor = .label
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    func setFavouritesButton(post: Post?) {
        guard let currentPost = post else {
            return
        }
        
        if currentPost.isFavourite {
            favouritesButton.tintColor = .label
            favouritesButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        } else {
            favouritesButton.tintColor = .lightGray
            favouritesButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        }
    }
}
