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
}
