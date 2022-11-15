//
//  FeedViewModel.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 08.10.2022.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

protocol FeedViewModelProtocol {
    var errorMessageChanged: ((String) -> Void)? { get set }
    var postLoaded: (() -> Void)? { get set }
    var postDidLiked: ((FeedTableViewCell) -> ())? { get set }
    var postDidSetFavourite: ((FeedTableViewCell) -> ())? { get set }
    var coordinator: FeedCoordinatorProtocol? { get set }
    var postsCollections: [PostCollection] { get set }
    func getFeed()
    func showPostInfo(in collection: Int, of post: Int)
    func showUserProfile(for user: User)
    func likePost(in cell: FeedTableViewCell, post: Post)
    func setPostInFavourites(in cell: FeedTableViewCell, post: Post)
}

class FeedViewModel: FeedViewModelProtocol {
    var coordinator: FeedCoordinatorProtocol?
    var postLoaded: (() -> Void)?
    var errorMessageChanged: ((String) -> Void)?
    var postsCollections: [PostCollection] = []
    var postDidLiked: ((FeedTableViewCell) -> ())?
    var postDidSetFavourite: ((FeedTableViewCell) -> ())?
    
    init(coordinator: FeedCoordinatorProtocol?) {
        self.coordinator = coordinator
    }
    
    func getFeed() {
        postsCollections = []
        
        let db = Firestore.firestore()
        let operationGroup = DispatchGroup()
        
        operationGroup.enter()
        DispatchQueue.global(qos: .userInitiated).async(group: operationGroup) {
            let reference = db.document("User/\(FirebaseAuth.Auth.auth().currentUser?.uid ?? "")")
            
            db.collection("Post").whereField("User",
                                             isNotEqualTo: reference).getDocuments() { (querySnapshot, error) in
                
                guard error == nil else {
                    self.errorMessageChanged?(error!.localizedDescription)
                    operationGroup.leave()
                    return
                }
                
                for document in querySnapshot!.documents {
                    //                    let documentData = document.data()
                    self.processPost(document: document, on: operationGroup)
                }
                
                operationGroup.leave()
            }
        }
        
        operationGroup.notify(queue: DispatchQueue.main) {
            self.postsCollections.sort {
                $0.date < $1.date
            }
            self.postLoaded?()
        }
    }
    
    private func processPost(document: QueryDocumentSnapshot, on operationGroup: DispatchGroup?) {
        let data = document.data()
        
        if let userData = data["User"] as? DocumentReference {
            operationGroup?.enter()
            userData.getDocument { querySnapshot, error in
                guard error == nil else {
                    self.errorMessageChanged?(error!.localizedDescription)
                    operationGroup?.leave()
                    return
                }
                
                let snapshotData = querySnapshot!.data()
                
                let currentAuthor = User(id: querySnapshot!.documentID,
                                         firstName: snapshotData!["firstName"] as? String,
                                         lastName: snapshotData!["lastName"] as? String,
                                         birthDate: nil,
                                         sex: .init(rawValue: (snapshotData!["sex"] as? String) ?? "male")!,
                                         avatar: snapshotData!["avatar"] as? String,
                                         phoneNumber: snapshotData!["phoneNumber"] as? String)
                
                let currentPost = Post(id: document.documentID,
                                       date: (data["Date"] as? Timestamp)?.dateValue(),
                                       likes: 0,
                                       text: data["Text"] as? String,
                                       author: currentAuthor,
                                       image: data["image"] as? String)
                
                self.loadLikesInfo(for: currentPost, on: operationGroup)
                self.loadFavouritesInfo(for: currentPost, on: operationGroup)
                
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
    
    private func loadFavouritesInfo(for post: Post, on group: DispatchGroup?) {
        let db = Firestore.firestore()
        let reference = db.document("Post/\(post.id)")
        let currentUserReference = db.document("User/\(FirebaseAuth.Auth.auth().currentUser?.uid ?? "")")
        
        group?.enter()
        db.collection("FavouritesPosts").whereField("post",
                                                   isEqualTo: reference).whereField("user",
                                                                                    isEqualTo: currentUserReference).getDocuments { snapshot, error in
                                                       guard error == nil else {
                                                           print(error!.localizedDescription)
                                                           group?.leave()
                                                           return
                                                       }
                                                       
                                                       for _ in snapshot!.documents {
                                                           post.isFavourite = true
                                                       }
                                                       group?.leave()
                                                   }
    }
    
    private func loadLikesInfo(for post: Post, on group: DispatchGroup?) {
        let db = Firestore.firestore()
        let reference = db.document("Post/\(post.id)")
        let currentUserReference = db.document("User/\(FirebaseAuth.Auth.auth().currentUser?.uid ?? "")")
        
        group?.enter()
        db.collection("PostsLikes").whereField("post", isEqualTo: reference).getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                group?.leave()
                return
            }
            
            for document in snapshot!.documents {
                post.likes += 1
                if let user = document.data()["user"] as? DocumentReference, user == currentUserReference {
                    post.isLiked = true
                }
            }
            group?.leave()
        }
    }
    
    func showPostInfo(in collection: Int, of post: Int) {
        let data = postsCollections[collection].posts[post]
        coordinator?.pushPostInfoView(with: data)
    }
    
    func showUserProfile(for user: User) {
        guard let moduleFactory = coordinator?.moduleFactory, let navigationController = coordinator?.navigationController else {
            return
        }
        
        let profileCoordinator = ProfileCoordinator(moduleFactory: moduleFactory,
                                                    navigationController: navigationController)
        profileCoordinator.pushProfileView(for: user, isCurrentUserProfile: false)
    }
    
    func likePost(in cell: FeedTableViewCell, post: Post) {
        let db = Firestore.firestore()
        let reference = db.document("Post/\(post.id)")
        let currentUserReference = db.document("User/\(FirebaseAuth.Auth.auth().currentUser?.uid ?? "")")
        
        if post.isLiked {
            db.collection("PostsLikes").whereField("post",
                                                   isEqualTo: reference).whereField("user",
                                                                                    isEqualTo: currentUserReference).getDocuments {[ weak self ] snapshot, error in
                                                       guard error == nil else {
                                                           print(error!.localizedDescription)
                                                           return
                                                       }
                                                       
                                                       let document = snapshot?.documents[0].reference
                                                       document?.delete() { error in
                                                           guard error == nil else {
                                                               print(error!.localizedDescription)
                                                               return
                                                           }
                                                           
                                                           post.isLiked = !post.isLiked
                                                           post.likes -= 1
                                                           
                                                           self?.postDidLiked?(cell)
                                                       }
            }
        } else {
            let documentData = [
                "post": reference,
                "user": currentUserReference
            ]
            db.collection("PostsLikes").addDocument(data: documentData) {[ weak self ] error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                
                post.isLiked = !post.isLiked
                post.likes += 1
                
                self?.postDidLiked?(cell)
            }
        }
    }
    
    func setPostInFavourites(in cell: FeedTableViewCell, post: Post) {
        let db = Firestore.firestore()
        let reference = db.document("Post/\(post.id)")
        let currentUserReference = db.document("User/\(FirebaseAuth.Auth.auth().currentUser?.uid ?? "")")
        
        if post.isFavourite {
           db.collection("FavouritesPosts").whereField("post",
                                                   isEqualTo: reference).whereField("user",
                                                                                    isEqualTo: currentUserReference).getDocuments {[ weak self ] snapshot, error in
                                                       guard error == nil else {
                                                           print(error!.localizedDescription)
                                                           return
                                                       }
                                                       
                                                       let document = snapshot?.documents[0].reference
                                                       document?.delete() { error in
                                                           guard error == nil else {
                                                               print(error!.localizedDescription)
                                                               return
                                                           }
                                                           
                                                           post.isFavourite = !post.isFavourite
                                                           self?.postDidSetFavourite?(cell)
                                                       }
            }
        } else {
            let documentData = [
                "post": reference,
                "user": currentUserReference
            ]
            db.collection("FavouritesPosts").addDocument(data: documentData) {[ weak self ] error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                
                post.isFavourite = !post.isFavourite
                self?.postDidSetFavourite?(cell)
            }
        }
    }
}
