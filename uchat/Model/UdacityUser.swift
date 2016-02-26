//
//  UdacityUser.swift
//  On the Map
//
//  Created by Wojtek Materka on 29/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Parse

struct UdacityUser {
    
    // MARK: - Properties
    static var udacityKey : String?
    static var username: String?

    // MARK: - Init
    
    // using First Name as the username to display in chat
    init(initCurrentUserFromData userData: [String:AnyObject]) {
        UdacityUser.udacityKey = userData[UClient.JSONResponseKeys.UserKey] as? String
        UdacityUser.username = userData[UClient.JSONResponseKeys.FirstName] as? String
    }
    
    static func clearData() {
        UdacityUser.username = nil
        UdacityUser.udacityKey = nil
    }

}
    


