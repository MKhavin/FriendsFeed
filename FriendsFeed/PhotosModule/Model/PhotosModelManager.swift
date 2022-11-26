import FirebaseFirestore
import FirebaseStorage

// MARK: - PhotosModelManager protocol
protocol PhotosModelManagerProtocol {
    var delegate: PhotosModelManagerDelegate? { get set }
    var photos: [String] { get }
    func loadUserPhotos(for user: String)
}

// MARK: - PhotosModelManagerDelegate protocol
protocol PhotosModelManagerDelegate: AnyObject {
    func userImagesDidLoad()
}

// MARK: - PhotosModelManager implementation
class PhotosModelManager: PhotosModelManagerProtocol {
    // MARK: - Properties
    weak var delegate: PhotosModelManagerDelegate?
    private(set) var photos = [String]()
    
    // MARK: - Methods
    func loadUserPhotos(for user: String) {
        let db = Firestore.firestore()
        let userReference = db.document("\(FirestoreTables.user.rawValue)/\(user)")
        
        db.collection(FirestoreTables.usersPhotos.rawValue).whereField(
            UsersPhoto.user.rawValue,
            isEqualTo: userReference
        ).getDocuments { [ weak self ] snapshot, error in
            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                print(error!.localizedDescription)
                // swiftlint:disable:previous force_unwrapping
                return
            }
            
            self?.photos = snapshot?.documents.map { snapshot -> String in
                let currentData = snapshot.data()
                return currentData[UsersPhoto.image.rawValue] as? String ?? ""
            } ?? []
            
            self?.delegate?.userImagesDidLoad()
        }
    }
}
