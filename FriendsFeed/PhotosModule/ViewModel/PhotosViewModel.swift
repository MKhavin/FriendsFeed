import Foundation
import FirebaseFirestore
import FirebaseStorage

protocol PhotosViewModelProtocol {
    var photosDidLoad: (() -> Void)? { get set }
    func loadUserPhotos()
    func getPhotosCount() -> Int
    func getPhoto(by photoNumber: Int) -> String
}

class PhotosViewModel: PhotosViewModelProtocol {
    private let coordinator: NavigationCoordinatorProtocol?
    private var photos = [String]()
    private let user: String
    var photosDidLoad: (() -> Void)?
    
    init(coordinator: NavigationCoordinatorProtocol?, user: String) {
        self.coordinator = coordinator
        self.user = user
    }
    
    func loadUserPhotos() {
        let db = Firestore.firestore()
        let userReference = db.document("User/\(user)")
        
        db.collection("UsersPhoto").whereField("user", isEqualTo: userReference).getDocuments { snapshot, error in
            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                print(error!.localizedDescription)
                // swiftlint:disable:previous force_unwrapping
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
