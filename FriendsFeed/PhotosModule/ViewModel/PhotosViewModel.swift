//
//  PhotosViewModel.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 05.11.2022.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

protocol PhotosViewModelProtocol {
    var photosDidLoad: (() -> ())? { get set }
    func loadUserPhotos()
    func getPhotosCount() -> Int
    func getPhoto(by photoNumber: Int) -> String
}

class PhotosViewModel: PhotosViewModelProtocol {
    private let coordinator: NavigationCoordinatorProtocol?
    private var photos = [String]()
    private let user: String
    var photosDidLoad: (() -> ())?
    
    init(coordinator: NavigationCoordinatorProtocol?, user: String) {
        self.coordinator = coordinator
        self.user = user
    }
    
    func loadUserPhotos() {
        let db = Firestore.firestore()
        #warning("Необходимо поменять алгоритм хранения УИД пользователя")
//        let userReference = db.document("User/\(user)")
        let userReference = db.document("User/fEJAjw5UHNOAmFvMkSRY2lAH0v02")
        
        db.collection("UsersPhoto").whereField("user", isEqualTo: userReference).getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            self.photos = snapshot?.documents.map { snapshot -> String in
                let currentData = snapshot.data()
                return currentData["image"] as? String ?? ""
            } ?? []
            
            self.photosDidLoad?()
        }
    }
    
    func getPhotosCount() -> Int {
        photos.count
    }
    
    func getPhoto(by photoNumber: Int) -> String {
        photos[photoNumber]
    }
}
