import UIKit

class PhotosViewController: UIViewController {
    private weak var mainView: PhotosView?
    var viewModel: PhotosViewModelProtocol!
    
    // MARK: - Life cycle
    override func loadView() {
        let newView = PhotosView()
        view = newView
        mainView = newView
        
        mainView?.photosCollection.dataSource = self
        mainView?.photosCollection.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.photosDidLoad = {
            self.mainView?.photosCollection.reloadData()
        }
        viewModel.loadUserPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Фотографии"
    }
}

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getPhotosCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemsIdentifier.photosCell.rawValue,
                                                            for: indexPath) as? PhotosCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let photo = viewModel.getPhoto(by: indexPath.item)
        cell.setCellImage(image: photo)
        
        return cell
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8,
                            left: 8,
                            bottom: 8,
                            right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = ((UIScreen.main.bounds.width - 8 * 4) / 3).rounded()
        return CGSize(width: size, height: size)
    }
}
