import Foundation

struct User {
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
    var phoneNumber: String?
    
    init(id: String, firstName: String?, lastName: String?, birthDate: Date?, sex: Sex, avatar: String?, phoneNumber: String?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.birthDate = birthDate
        self.sex = sex
        self.avatar = avatar
        self.phoneNumber = phoneNumber
    }
}
