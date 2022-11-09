//
//  PhotosView.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 05.11.2022.
//

import UIKit

class PhotosView: UIView {
    
    //MARK: - UI Elements
    private(set) lazy var photosCollection: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: ItemsIdentifier.photosCell.rawValue)
        return view
    }()

    //MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        addSubview(photosCollection)
        setSubViewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Sub methods
    private func setSubViewsLayout() {
        photosCollection.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
}
