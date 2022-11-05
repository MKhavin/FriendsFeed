import UIKit

class ProfilePhotosTableViewCell: UITableViewCell {
    //MARK: - UI Elements
    private lazy var headerStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.contentMode = .scaleAspectFill
        view.spacing = 10
        return view
    }()
    
    private lazy var headerLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Photos"
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.textColor = .black
        return view
    }()
    
    private lazy var headerImage: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "arrow.right"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .black
        return view
    }()
    
    private lazy var photosStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.contentMode = .scaleAspectFill
        view.spacing = 8
        return view
    }()
    var viewModel: ProfilePhotosViewModelProtocol!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        viewModel = ProfilePhotosViewModel()
        viewModel.imagesDidLoad = {
            switch $0 {
            case .success(let result):
                self.setPhotos(by: result)
            case .failure(let error):
                print(error)
            }
        }
        
        setSubViews()
        setSubViewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func setSubViews() {
        contentView.addSubviews([
            headerStack,
            photosStack
        ])
        headerStack.addArrangedSubview(headerLabel)
        headerStack.addArrangedSubview(headerImage)
        
        viewModel.loadUserImages()
    }
    
    private func setSubViewsLayout() {
        let photosTableViewItemInset: CGFloat = 12
        
        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: contentView.topAnchor,
                                             constant: photosTableViewItemInset),
            headerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                 constant: photosTableViewItemInset),
            headerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                  constant: -photosTableViewItemInset)
        ])
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: headerStack.topAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: headerStack.bottomAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: headerStack.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            headerImage.topAnchor.constraint(equalTo: headerStack.topAnchor),
            headerImage.bottomAnchor.constraint(equalTo: headerStack.bottomAnchor),
            headerImage.trailingAnchor.constraint(equalTo: headerStack.trailingAnchor),
            headerImage.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor),
            headerImage.widthAnchor.constraint(equalToConstant: 25)
        ])
        
        NSLayoutConstraint.activate([
            photosStack.topAnchor.constraint(equalTo: contentView.subviews[0].bottomAnchor,
                                             constant: photosTableViewItemInset),
            photosStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                constant: -photosTableViewItemInset),
            photosStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                 constant: photosTableViewItemInset),
            photosStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                  constant: -photosTableViewItemInset)
        ])
    }
    
    private func setPhotos(by images: [String]) {
        let minCount = min(images.count, 3)
        for number in 0..<minCount {
            let image = CachedImageView()
            image.getImageFor(imagePath: images[number])
            image.translatesAutoresizingMaskIntoConstraints = false
            image.layer.cornerRadius = 6
            image.clipsToBounds = true
            photosStack.addArrangedSubview(image)
            image.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width
                                                           - 12 * 3
                                                           - 8)
                                         / CGFloat(minCount)).isActive = true
            image.heightAnchor.constraint(equalTo: image.widthAnchor).isActive = true
        }
    }
    
    //remove cell line borders
    override func addSubview(_ view: UIView) {
        if (view.frame.height * UIScreen.main.scale) == 1 {
            return
        }
        
        super.addSubview(view)
    }
    
}
