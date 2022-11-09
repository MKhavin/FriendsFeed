//
//  UIStackViewExtensions.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 04.10.2022.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.forEach { view in
            addArrangedSubview(view)
        }
    }
    
    func resetStack() {
        var count = arrangedSubviews.count
        
        while count != 0 {
            let view = arrangedSubviews[count - 1]
            NSLayoutConstraint.deactivate(view.constraints)
            removeArrangedSubview(view)
            view.removeFromSuperview()
            count -= 1
        }
    }
}
