//
//  UILabelWithPadding.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 06.10.2022.
//

import UIKit

class UILabelWithPadding: UILabel {
    //MARK: - Sub properties
    var contentInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

    //MARK: - Life cycle
    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: contentInsets)
        super.drawText(in: insetRect)
    }

    override var intrinsicContentSize: CGSize {
        return addInsets(to: super.intrinsicContentSize)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return addInsets(to: super.sizeThatFits(size))
    }

    //MARK: - Sub methods
    private func addInsets(to size: CGSize) -> CGSize {
        let width = size.width + contentInsets.left + contentInsets.right
        let height = size.height + contentInsets.top + contentInsets.bottom
        return CGSize(width: width, height: height)
    }
}
