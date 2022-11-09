//
//  Post.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 08.10.2022.
//

import Foundation

struct Post {
    let date: Date
    let likes: UInt?
    let text: String
    var author: User
    var image: String?
}

extension Post {
    init(date: Date?, likes: UInt?, text: String?, author: User?, image: String?) {
        self.date = date ?? Date()
        self.likes = likes ?? 0
        self.text = text ?? ""
        self.author = author ?? User(id: "",
                                     firstName: "",
                                     lastName: "",
                                     birthDate: nil,
                                     sex: .male,
                                     avatar: nil,
                                     phoneNumber: nil)
        self.image = image
    }
}
