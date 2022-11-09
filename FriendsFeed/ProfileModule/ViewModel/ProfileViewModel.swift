//
//  ProfileViewModel.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 25.10.2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol ProfileViewModelProtocol {
    var userDataDidLoaded: ((Result<User?, Error>) -> ())? { get set }
    var postsDataDidLoad: ((Error?) -> ())? { get set }
    var isCurrentUserProfile: Bool { get }
    func loadUserData()
    func getPostsCount() -> Int
    func getPostData(for postNumber: Int) -> Post
    func pushPostInfo(for postNumber: Int)
    func pushPhotosView()
    func getUserInfo() -> User?
}

class ProfileViewModel: ProfileViewModelProtocol {
    var postsDataDidLoad: ((Error?) -> ())?
    var userDataDidLoaded: ((Result<User?, Error>) -> ())?
    private(set) var isCurrentUserProfile: Bool
    private var coordinator: ProfileCoordinatorProtocol?
    private var model: ProfileModelManagerProtocol
    
    init(model: ProfileModelManagerProtocol, coordinator: ProfileCoordinatorProtocol?, isCurrentProfile: Bool) {
        self.isCurrentUserProfile = isCurrentProfile
        self.coordinator = coordinator
        self.model = model
        self.model.delegate = self
    }
    
    func loadUserData() {
        model.loadUserData()
    }
    
    func getPostsCount() -> Int {
        model.posts.count
    }
    
    func getPostData(for postNumber: Int) -> Post {
        model.posts[postNumber]
    }
    
    func pushPostInfo(for postNumber: Int) {
        let postData = getPostData(for: postNumber)
        coordinator?.pushPostInfoView(with: postData)
    }
    
    func pushPhotosView() {
        coordinator?.pushPhotosView(for: model.profile?.id ?? "")
    }
    
    func getUserInfo() -> User? {
        model.profile
    }
}

extension ProfileViewModel: ProfileModelManagerDelegateProtocol {
    func userDataDidLoad(_ result: Result<User?, Error>) {
        userDataDidLoaded?(result)
    }
    
    func postDataDidLoad(_ error: Error?) {
        postsDataDidLoad?(error)
    }
}