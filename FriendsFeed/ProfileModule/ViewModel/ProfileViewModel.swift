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
    func loadUserData(by login: String?)
    func getPostsCount() -> Int
    func getPostData(for postNumber: Int) -> Post
    func pushPostInfo(for postNumber: Int)
}

class ProfileViewModel: ProfileViewModelProtocol {
    var postsDataDidLoad: ((Error?) -> ())?
    var userDataDidLoaded: ((Result<User?, Error>) -> ())?
    private var coordinator: ProfileCoordinatorProtocol?
    private var profile: User?
    private let group: DispatchGroup = DispatchGroup()
    private var errorOccured = false
    private var currentLogin: String!
    private var posts: [Post] = []
    
    enum SubInformationData {
        case postsCount
        case subscriptionsCount
        case friendsCount
        
        func getCollectionName() -> String {
            switch self {
            case .postsCount:
                return "Post"
            case .subscriptionsCount, .friendsCount:
                return "Subscription"
            }
        }
    }
    
    init(coordinator: ProfileCoordinatorProtocol?) {
        self.coordinator = coordinator
    }
    
    func loadUserData(by login: String?) {
        if login == nil {
            if let user = Auth.auth().currentUser, let phone = user.phoneNumber {
                currentLogin = phone
            } else {
              return
            }
        } else {
            currentLogin = login!
        }
        
        group.enter()
        let db = Firestore.firestore()
        db.collection("User").whereField("id", isEqualTo: currentLogin!).getDocuments() { (querySnapshot, error) in
            guard error == nil else {
                self.errorOccured = true
                print(error!.localizedDescription)
                self.userDataDidLoaded?(.failure(error!))
                self.group.leave()
                return
            }
            
            querySnapshot?.documents.forEach({ [weak self] snapshot in
                let userData = snapshot.data()
                let documentId = snapshot.documentID
                
                self?.profile = User(id: self?.currentLogin ?? "",
                               firstName: userData["firstName"] as? String,
                               lastName: userData["lastName"] as? String,
                               birthDate: userData["birthDate"] as? Date,
                               sex: .init(rawValue: userData["sex"] as? String ?? "male") ?? .male,
                               avatar: userData["avatar"] as? String)
                
                self?.getSubInformation(.postsCount, for: documentId)
                self?.getSubInformation(.subscriptionsCount, for: documentId, field: "user")
                self?.getSubInformation(.friendsCount, for: documentId, field: "subscription")
                self?.group.leave()
            })
        }
        
        group.notify(queue: .main) {
            self.userDataDidLoaded?(.success(self.profile))
            self.loadPostsData()
        }
    }
    
    func getPostsCount() -> Int {
        posts.count
    }
    
    private func getSubInformation(_ type: SubInformationData, for userId: String, field: String = "User") {
        let db = Firestore.firestore()
        let reference = db.document("User/\(userId)")
        
        group.enter()
        db.collection(type.getCollectionName()).whereField(field, isEqualTo: reference).getDocuments {[weak self] snapshot, error in
            guard error == nil else {
                self?.userDataDidLoaded?(.failure(error!))
                print(error!.localizedDescription)
                self?.errorOccured = true
                self?.group.leave()
                return
            }
            
            switch type {
            case .postsCount:
                self?.profile?.postsCount = snapshot?.documents.count ?? 0
            case .subscriptionsCount:
                self?.profile?.subscriptions = snapshot?.documents.count ?? 0
            case .friendsCount:
                self?.profile?.friends = snapshot?.documents.count ?? 0
            }

            self?.group.leave()
        }
    }
    
    private func loadPostsData() {
        let db = Firestore.firestore()
        let userReference = db.document("User/\(FirebaseAuth.Auth.auth().currentUser?.uid ?? "")")
        db.collection("Post").whereField("User", isEqualTo: userReference).getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                self.postsDataDidLoad?(error!)
                return
            }
            
            self.posts = snapshot?.documents.map { document -> Post in
                let postData = document.data()
                
                return Post(date: Date(timeIntervalSince1970: postData["Date"] as? Double ?? 0),
                            likes: postData["Likes"] as? UInt,
                            text: postData["Text"] as? String,
                            author: self.profile, //????
                            image: postData["image"] as? String)
            } ?? []
            
            self.postsDataDidLoad?(nil)
        }
    }
    
    func getPostData(for postNumber: Int) -> Post {
        posts[postNumber]
    }
    
    func pushPostInfo(for postNumber: Int) {
        let postData = getPostData(for: postNumber)
        coordinator?.pushPostInfoView(with: postData)
    }
}
