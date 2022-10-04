//
//  UIColorExtension.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 19.09.2022.
//

import UIKit

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat) {
        let red = Double((hex >> 16) & 0xFF) / 255.0
        let green = Double((hex >> 8) & 0xFF) / 255.0
        let blue = Double(hex & 0xFF) / 255.0
        
        self.init(red: red,
                  green: green,
                  blue: blue,
                  alpha: alpha)
    }
}
