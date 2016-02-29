//
//  Channel.swift
//  uchat
//
//  Created by Wojtek Materka on 21/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Foundation


struct Channel {
    
    // MARK: - Properties
    
    let name: String
    let tagline: String
    var messages: [Message] = []
    
    init(name: String, tagline: String) {
        self.name = name
        self.tagline = tagline
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
// There is no channel object on the server for global data persistence, perhaps in a next version?
// So it kinda works like CB-Radio 📻

import Parse

extension Channel {
    
    // Subscribe user
    mutating func subscribeUser() {
            
        PFPush.subscribeToChannelInBackground(self.name) { succeeded, error in
            if succeeded {
                print("🚀 Successfully subscribed to channel: \(self.name).")
            } else {
                print("🆘 🚀 Failed to subscribe to channel: \(self.name) with Parse error: \n \(error)")
            }
        }
    }
    
    // Unsubscribe user
    mutating func unsubscribeUser() {

        PFPush.unsubscribeFromChannelInBackground(self.name) { succeeded, error in
            if succeeded {
                print("🚀 Unsubscribed from \(self.name)")
            } else {
                print("🆘 🚀 Failed to leave channel: \(self.name) with Parse error: \n \(error)")
            }
        }
    }
    
}
