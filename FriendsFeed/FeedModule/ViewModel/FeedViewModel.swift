//
//  FeedViewModel.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 08.10.2022.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

protocol FeedViewModelProtocol {
    var errorMessageChanged: ((String) -> Void)? { get set }
    var postLoaded: (() -> Void)? { get set }
    var coordinator: FeedCoordinatorProtocol? { get set }
    var postsCollections: [PostCollection] { get set }
    func getFeed()
    func showPostInfo(in collection: Int, of post: Int)
}

class FeedViewModel: FeedViewModelProtocol {
    var coordinator: FeedCoordinatorProtocol?
    var postLoaded: (() -> Void)?
    var errorMessageChanged: ((String) -> Void)?
    var postsCollections: [PostCollection] = []
    
    init(coordinator: FeedCoordinatorProtocol?) {
        self.coordinator = coordinator
    }
    
    func getFeed() {
        let db = Firestore.firestore()
        let operationGroup = DispatchGroup()
        
        operationGroup.enter()
        DispatchQueue.global(qos: .userInitiated).async(group: operationGroup) {
            db.collection("Post").order(by: "Date", descending: true).getDocuments() { (querySnapshot, error) in
                
                guard error == nil else {
                    self.errorMessageChanged?(error!.localizedDescription)
                    operationGroup.leave()
                    return
                }
                
                for document in querySnapshot!.documents {
                    let documentData = document.data()
                    self.processPost(data: documentData, on: operationGroup)
                }
                
                operationGroup.leave()
            }
        }
        
        operationGroup.notify(queue: DispatchQueue.main) {
            self.postLoaded?()
        }
    }
    
    private func processPost(data: [String: Any], on operationGroup: DispatchGroup?) {
        if let userData = data["User"] as? DocumentReference {
            operationGroup?.enter()
            userData.getDocument { querySnapshot, error in
                guard error == nil else {
                    self.errorMessageChanged?(error!.localizedDescription)
                    operationGroup?.leave()
                    return
                }
                
                let snapshotData = querySnapshot!.data()
                
                let currentAuthor = User(id: snapshotData!["id"] as! String,
                                     firstName: snapshotData!["firstName"] as? String,
                                     lastName: snapshotData!["lastName"] as? String,
                                     birthDate: nil,
                                     sex: .init(rawValue: snapshotData!["sex"] as! String)!,
                                     avatar: snapshotData!["avatar"] as? String)
                
                let currentPost = Post(date: (data["Date"] as? Timestamp)?.dateValue(),
                                       likes: data["Likes"] as? UInt,
                                       text: data["Text"] as? String,
                                       author: currentAuthor,
                                       image: data["image"] as? String)
                
                let postCollection = self.postsCollections.firstIndex { collection in
                    collection.date.formatted(by: "MM/dd/yyyy") == currentPost.date.formatted(by: "MM/dd/yyyy")
                }

                if postCollection == nil {
                    self.postsCollections.append(PostCollection(date: currentPost.date, posts: [currentPost]))
                } else {
                    self.postsCollections[postCollection!].posts.append(currentPost)
                }
                
                operationGroup?.leave()
            }
        }
    }
    
    func showPostInfo(in collection: Int, of post: Int) {
        let data = postsCollections[collection].posts[post]
        coordinator?.pushPostInfoView(with: data)
    }
}
