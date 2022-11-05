//
//  ProfilePhotosViewModel.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 30.10.2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol ProfilePhotosViewModelProtocol {
    var imagesDidLoad: ((Result<[String], Error>) -> ())? { get set }
    func loadUserImages()
}

class ProfilePhotosViewModel: ProfilePhotosViewModelProtocol {
    var imagesDidLoad: ((Result<[String], Error>) -> ())?
    
    func loadUserImages() {
        //let login = user.phoneNumber
        if let user = FirebaseAuth.Auth.auth().currentUser {
            let login = user.uid
            let db = Firestore.firestore()
            let userReference = db.document("User/\(login)")
            db.collection("UsersPhoto").whereField("user", isEqualTo: userReference).getDocuments { snapshot, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    self.imagesDidLoad?(.failure(error!))
                    return
                }
                
                let imagesList = snapshot?.documents.map({ snapshot -> String in
                    let data = snapshot.data()
                    return data["image"] as? String ?? ""
                }) ?? []
                
                self.imagesDidLoad?(.success(imagesList))
            }
        }
    }
}
