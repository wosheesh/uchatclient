//
//  Channel.swift
//  uchat
//
//  Created by Wojtek Materka on 21/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Foundation


public final class Channel: ManagedObject {
    
    // MARK: - Properties
    @NSManaged public private(set) var code: String
    @NSManaged public private(set) var name: String
    @NSManaged public private(set) var tagline: String
    var picturePath: String?
    var messages: [Message] = []
    
    init(code: String, name: String, tagline: String) {
        self.code = code
        self.name = name
        self.tagline = tagline
    }
    
    // TODO: hold image as UIImage in memory after loading
    func pictureFilename() -> String {
        return code + ".jpg"
    }
}

// MARK: - Receive new message in channel

extension Channel {
    
    mutating func Receive(var message: Message) -> Message {
        message.receivedAt = NSDate()
        self.messages.append(message)
        return message
    }
    
}

// MARK: - (un)Subscribe user to channel

// This is currently done as notification channel subscription.

import Parse

extension Channel {
    
    // Subscribe user
    mutating func subscribeUser() {
            
        PFPush.subscribeToChannelInBackground(self.code) { succeeded, error in
            if succeeded {
                print("🚀 Successfully subscribed to channel: \(self.code).")
            } else {
                print("🆘 🚀 Failed to subscribe to channel: \(self.code) with Parse error: \n \(error)")
            }
        }
    }
    
    // Unsubscribe user
    mutating func unsubscribeUser() {

        PFPush.unsubscribeFromChannelInBackground(self.code) { succeeded, error in
            if succeeded {
                print("🚀 Unsubscribed from \(self.code)")
            } else {
                print("🆘 🚀 Failed to leave channel: \(self.code) with Parse error: \n \(error)")
            }
        }
    }
    
}
