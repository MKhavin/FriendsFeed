//
//  PostInfoViewModel.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 20.10.2022.
//

import Foundation

protocol PostInfoViewModelProtocol {
    var coordinator: NavigationCoordinatorProtocol? { get set }
    var postDataLoaded: ((Post) -> ())? { get set }
    func loadPostData()
}

class PostInfoViewModel: PostInfoViewModelProtocol {
    var postDataLoaded: ((Post) -> ())?
    var coordinator: NavigationCoordinatorProtocol?
    private let post: Post
    
    init(coordinator: NavigationCoordinatorProtocol?, data: Post) {
        self.coordinator = coordinator
        self.post = data
    }
    
    func loadPostData() {
        postDataLoaded?(post)
    }
}
