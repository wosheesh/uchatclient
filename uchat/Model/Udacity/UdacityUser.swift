//
//  UdacityUser.swift
//  On the Map
//
//  Created by Wojtek Materka on 29/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

//TODO: Change the User model to accommodate ultiple users

import Foundation

struct UdacityUser {
    
    // Udacity User properties
    static var udacityKey : String?
    static var firstName : String?
    static var lastName : String?
    
    static var currentUser = User(username: firstName!, currentChannel: nil)

    // MARK: - Init
    
    init(udacityKey: String, firstName: String, lastName: String) {
        UdacityUser.udacityKey = udacityKey
        UdacityUser.firstName = firstName
        UdacityUser.lastName = lastName
    }
    
    // MARK: - 🐵 Helpers
    
    /// Sets the current channel of the UdacityUser.currentUser
    /// and subscribes to appropriate notifications. If channel is nil
    /// removes unsubscribes from last notification
    
    static func setChannel(channel: Channel?) throws {
        
        if channel == nil {
            OneSignal.deleteUserTag(UdacityUser.currentUser.currentChannel)
            UdacityUser.currentUser.currentChannel = nil
            
        }
        
    }

    
    static func udacityUserFromUserData(userData: [String:AnyObject]) -> UdacityUser {
        let user = UdacityUser(
            udacityKey: userData[UClient.JSONResponseKeys.UserKey] as! String,
            firstName: userData[UClient.JSONResponseKeys.FirstName] as! String,
            lastName: userData[UClient.JSONResponseKeys.LastName] as! String)
        
        return user
    }
    
    static func logout() {
        udacityKey = nil
        firstName = nil
        lastName = nil
        self.currentUser.clearData()
    }
    
}



