//
//  User.swift
//  uchat
//
//  Created by Wojtek Materka on 22/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Foundation

protocol chatUser {
    var username: String? { get }
    var currentChannel: Channel? { get set }
}

struct User: chatUser {
    var username: String?
    var currentChannel: Channel?
    
    mutating func clearData() {
        username = nil
        currentChannel = nil
    }
}
    

