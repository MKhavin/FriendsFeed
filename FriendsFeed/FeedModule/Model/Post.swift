//
//  Post.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 08.10.2022.
//

import Foundation

class Post {
    let id: String
    let date: Date
    var likes: UInt
    let text: String
    var author: User?
    var image: String?
    var isLiked: Bool = false
    var isFavourite: Bool = false
    
    init(id: String, date: Date?, likes: UInt, text: String?, author: User?, image: String?) {
        self.id = id
        self.date = date ?? Date()
        self.likes = likes
        self.text = text ?? ""
        self.author = author 
        self.image = image
    }
}
