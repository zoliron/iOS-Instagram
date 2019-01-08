//
//  User.swift
//  Instagram
//
//  Created by Ronen on 03/01/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class UserModel {
    var email: String?
    var profileImageUrl: String?
    var username: String?
    var id: String?
    var isFollowing: Bool?
}

// Extension to User which will replace inits for more clear coding instead of overriding inits
extension UserModel {
    static func transformUser(dict: [String: Any], key: String) -> UserModel {
        let user = UserModel()
        user.email = dict["email"] as? String
        user.profileImageUrl = dict["profileImageUrl"] as? String
        user.username = dict["username"] as? String
        user.id = key
        return user
    }
}
