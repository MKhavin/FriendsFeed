//
//  UIViewExtension.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 15.09.2022.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { view in
            addSubview(view)
        }
    }
}
