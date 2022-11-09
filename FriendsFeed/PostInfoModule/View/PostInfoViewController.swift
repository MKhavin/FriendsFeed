//
//  PostInfoViewController.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 19.10.2022.
//

import UIKit

class PostInfoViewController: UIViewController {
    //MARK: - Sub properties
    var viewModel: PostInfoViewModelProtocol! {
        didSet {
            viewModel.postDataLoaded = { [weak self] postData in
                self?.mainView?.postTextLabel.text = postData.text
                self?.mainView?.postImageView.getImageFor(imagePath: postData.image ?? "")
                self?.mainView?.postTitleView.avatarImageView.getImageFor(imagePath: postData.author.avatar ?? "")
                self?.mainView?.postTitleView.nameLabel.text = postData.author.firstName
                self?.mainView?.postTitleView.subNameLabel.text = postData.author.lastName
                self?.mainView?.postBottomView.likeButton.setTitle("\(postData.likes ?? 0)", for: .normal)
            }
        }
    }
    private weak var mainView: PostInfoView?
    
    //MARK: - Life cycle
    override func loadView() {
        let currentView = PostInfoView()
        mainView = currentView
        view = currentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Публикации"
        
        viewModel.loadPostData()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(postTitleDidTap(_:)))
        mainView?.postTitleView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    @objc private func postTitleDidTap(_ sender: UIView) {
        viewModel.showProfileInfo()
    }
}
