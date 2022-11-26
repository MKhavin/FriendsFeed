// MARK: - PhotosViewModel protocol
protocol PhotosViewModelProtocol {
    var photosDidLoad: (() -> Void)? { get set }
    func loadUserPhotos()
    func getPhotosCount() -> Int
    func getPhoto(by photoNumber: Int) -> String
}

// MARK: - PhotosViewModel implementation
class PhotosViewModel: PhotosViewModelProtocol {
    // MARK: - Properties
    private let coordinator: NavigationCoordinatorProtocol?
    private let user: String
    private var modelManager: PhotosModelManagerProtocol?
    var photosDidLoad: (() -> Void)?
    
    // MARK: - Life cycle
    init(coordinator: NavigationCoordinatorProtocol?, modelManager: PhotosModelManagerProtocol?, user: String) {
        self.modelManager = modelManager
        self.coordinator = coordinator
        self.user = user
    }
    
    // MARK: - Methods
    func loadUserPhotos() {
        modelManager?.loadUserPhotos(for: user)
    }
    
    func getPhotosCount() -> Int {
        modelManager?.photos.count ?? 0
    }
    
    func getPhoto(by photoNumber: Int) -> String {
        modelManager?.photos[photoNumber] ?? ""
    }
}

// MARK: - PhotosViewModelManager delegate implementation
extension PhotosViewModel: PhotosModelManagerDelegate {
    func userImagesDidLoad() {
        photosDidLoad?()
    }
}
