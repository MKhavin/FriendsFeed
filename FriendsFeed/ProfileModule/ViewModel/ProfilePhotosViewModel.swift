import FirebaseAuth
import FirebaseFirestore

protocol ProfilePhotosViewModelProtocol {
    var imagesDidLoad: ((Result<[String], Error>) -> Void)? { get set }
    func loadUserImages()
}

class ProfilePhotosViewModel: ProfilePhotosViewModelProtocol {
    var imagesDidLoad: ((Result<[String], Error>) -> Void)?
    private var user: User
    
    init(user: User) {
        self.user = user
    }
    
    func loadUserImages() {
        let db = Firestore.firestore()
        let userReference = db.document("User/\(user.id)")
        db.collection("UsersPhoto").whereField("user", isEqualTo: userReference).getDocuments { snapshot, error in
            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                print(error!.localizedDescription)
                self.imagesDidLoad?(.failure(error!))
                // swiftlint:disable:previous force_unwrapping
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
