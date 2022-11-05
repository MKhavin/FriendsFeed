//
//  PhotosCollectionTableViewCell.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 05.11.2022.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    private lazy var photo: CachedImageView = {
        let view = CachedImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .black
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(photo)
        setSubviewsLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSubviewsLayout() {
        photo.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    func setCellImage(image: String) {
        photo.getImageFor(imagePath: image)
    }
    
}
