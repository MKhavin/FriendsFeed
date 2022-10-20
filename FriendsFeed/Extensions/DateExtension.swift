//
//  DateExtension.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 18.10.2022.
//

import Foundation

extension Date {
    func formatted(by format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = .current
        
        return dateFormatter.string(from: self)
    }
}
