import UIKit

class ProfileTitleButton: UIButton {
    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        super.setImage(image, for: state)
        
        imageView?.contentMode = .scaleAspectFit
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if imageView != nil {
            imageEdgeInsets = UIEdgeInsets(top: bounds.minY, left: bounds.midX / 2, bottom: bounds.midY, right: bounds.midX / 2)
            titleEdgeInsets = UIEdgeInsets(top: bounds.midY - 2, left: -bounds.midX / 2, bottom: 0, right: 0)
        }
    }
}
