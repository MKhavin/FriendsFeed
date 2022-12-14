import UIKit
import FirebaseStorage

final class CachedImageView: UIImageView {
    // MARK: - Sub properties
    static let cache: NSCache<NSString, NSData> = NSCache()
    
    // MARK: - UI elements
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.backgroundColor = UIColor(
            red: 0,
            green: 0,
            blue: 0,
            alpha: 0.2
        )
        view.clipsToBounds = true
        view.startAnimating()
        
        return view
    }()
    
    // MARK: - Life cycle
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(activityIndicatorView)
        setSubviewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Sub methods
    private func setSubviewsLayout() {
        activityIndicatorView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    private func setNewImage(by imageData: Data) {
        DispatchQueue.main.async {
            self.image = UIImage(data: imageData)
            self.activityIndicatorView.isHidden = true
        }
    }
    
    private func downloadFor(imagePath: String) {
        let storage = Storage.storage()
        
        let imageReference = storage.reference(forURL: imagePath)
        
        imageReference.getData(maxSize: 1024 * 1024 * 1024) { data, error in
            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                print(error!.localizedDescription)
                // swiftlint:disable:previous force_unwrapping
                
                if let url = Bundle.main.url(forResource: "FriendsFeed", withExtension: "pdf"),
                   let defaultImage = try? Data(contentsOf: url) {
                    self.setNewImage(by: defaultImage)
                }
                return
            }
            
            if let unwrappedData = data {
                self.setNewImage(by: unwrappedData)
                CachedImageView.cache.setObject(
                    NSData(data: unwrappedData),
                    forKey: NSString(string: imagePath)
                )
            }
        }
    }
    
    func getImageFor(imagePath: String) {
        guard !imagePath.isEmpty else {
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let imageData = CachedImageView.cache.object(forKey: NSString(string: imagePath)) {
                DispatchQueue.main.async {
                    let rawImage = UIImage(data: imageData as Data)
                    self.image = UIImage(data: rawImage?.jpegData(compressionQuality: 0.5) ?? Data())
                    self.activityIndicatorView.isHidden = true
                }
            } else {
                self.downloadFor(imagePath: imagePath)
                DispatchQueue.main.async {
                    self.activityIndicatorView.isHidden = false
                }
            }
        }
    }
}
