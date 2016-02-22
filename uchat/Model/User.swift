//
//  User.swift
//  uchat
//
//  Created by Wojtek Materka on 22/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Foundation

struct User {
    var username: String
    
    static func currentUser() -> User {
        return User(username: UdacityUser.firstName!)
    }
}