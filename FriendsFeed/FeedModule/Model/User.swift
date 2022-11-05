//
//  User.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 08.10.2022.
//

import Foundation

class User {
    enum Sex: String {
        case male, female
    }
    
    let id: String
    let firstName: String?
    let lastName: String?
    let birthDate: Date?
    let sex: Sex
    var avatar: String?
    var postsCount: Int = 0
    var subscriptions: Int = 0
    var friends: Int = 0
    
    init(id: String, firstName: String?, lastName: String?, birthDate: Date?, sex: Sex, avatar: String?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.birthDate = birthDate
        self.sex = sex
        self.avatar = avatar
    }
}
