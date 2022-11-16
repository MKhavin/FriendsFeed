import UIKit

extension UIStackView {
    func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.forEach { view in
            addArrangedSubview(view)
        }
    }
    
    func resetStack() {
        var subViewsCount = arrangedSubviews.count
        
        while subViewsCount > 0 {
            let view = arrangedSubviews[subViewsCount - 1]
            NSLayoutConstraint.deactivate(view.constraints)
            removeArrangedSubview(view)
            view.removeFromSuperview()
            subViewsCount -= 1
        }
    }
}
