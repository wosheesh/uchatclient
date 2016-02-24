//
//  UdacityUser.swift
//  On the Map
//
//  Created by Wojtek Materka on 29/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

//TODO: Change the User model to accommodate ultiple users

import Parse

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
    
    //TODO: throw error if change failed
    
    /// Changes channel for the currentUser and subscribes to its notifications
    /// If channel is nil removes unsubscribes from last notification
    static func setChannel(channel: Channel?) {
        
        // unsubscribe from current channel if there is one
        if let oldChannel = UdacityUser.currentUser.currentChannel {
            PFPush.unsubscribeFromChannelInBackground(oldChannel.name, block: { (succeeded, error) -> Void in
                if succeeded {
                    UdacityUser.currentUser.currentChannel = nil
                    print("🚀 Unsubscribed from \(oldChannel.name)")
                } else {
                    print("🆘 🚀 Failed to leave channel: \(oldChannel.name) with error: \n \(error)")
                }
            })
        }
        
        // if the new channel is not nil subscribe to it
        if let newChannel = channel {
            
            PFPush.subscribeToChannelInBackground(newChannel.name) { (succeeded: Bool, error: NSError?) in
                if succeeded {
                    UdacityUser.currentUser.currentChannel = newChannel
                    print("🚀 Successfully subscribed to channel: \(newChannel.name).")
                } else {
                    print("🆘 🚀 Failed to subscribe to channel: \(newChannel.name) with error: \n \(error)")
                }

            }
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
        
        UdacityUser.setChannel(nil)
        
        udacityKey = nil
        firstName = nil
        lastName = nil
        self.currentUser.clearData()
    }
    
}



