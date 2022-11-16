//
//  ProfileEditView.swift
//  FriendsFeed
//
//  Created by Michael Khavin on 09.11.2022.
//

import UIKit

class ProfileEditView: UIView {
    private lazy var nameTextView: UITextView = {
       let view = UITextView()
        
        return view
    }()
    private lazy var surnameTextView: UITextView = {
        let view = UITextView()
        
        return view
    }()
    private lazy var sexTextView: UITextView = {
        let view = UITextView()
        view.isEditable = false
        
        return view
    }()
    private lazy var birthDate: UITextView = {
       let view = UITextView()
        
        return view
    }()
//    private lazy var city: UITextView = {
//
//    }
}
