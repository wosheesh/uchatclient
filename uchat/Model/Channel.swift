//
//  Channel.swift
//  uchat
//
//  Created by Wojtek Materka on 21/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import CoreData


public final class Channel: ManagedObject {
    
    // MARK: - Properties
    
    @NSManaged public private(set) var code: String
    @NSManaged public private(set) var name: String
    @NSManaged public private(set) var tagline: String
    @NSManaged public private(set) var picturePath: String?
    @NSManaged public private(set) var messages: Set<Message>
    
    // This in effect is the init
    public static func insertIntoContext(moc: NSManagedObjectContext, code: String, name: String, tagline: String, picturePath: String?) -> Channel {
        let channel: Channel = moc.insertObject()
        channel.code = code
        channel.name = name
        channel.tagline = tagline
        channel.picturePath = picturePath
        return channel
    }
    
    
    // TODO: hold image as UIImage in memory after loading
//    func pictureFilename() -> String {
//        return code + ".jpg"
//    }
}



extension Channel: ManagedObjectType {
    public static var entityName: String {
        return "Channel"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [] // not needed...
    }
    
    public static func findOrCreateChannel(code: String, name: String, tagline:String, picturePath: String?, inContext moc: NSManagedObjectContext) -> Channel {
        let predicate = NSPredicate(format: "code == %@", code)
        let channel = findOrCreateInContext(moc, matchingPredicate: predicate) {
            print("creating a new channel: \(code)")
            $0.code = code
            $0.name = name
            $0.tagline = tagline
            $0.picturePath = picturePath
        }
        return channel
    }
}


// MARK: - Receive new message in channel
extension Channel {
    
//    mutating func Receive(var message: Message) -> Message {
//        message.receivedAt = NSDate()
//        self.messages.append(message)
//        return message
//    }
    
}

// MARK: - (un)Subscribe user to channel
// This is currently done as notification channel subscription.

import Parse

extension Channel {
    
    // Subscribe user
    func subscribeUser(inView sender: ChatViewController) {
        
        NSNotificationCenter.defaultCenter().addObserver(sender, selector: "displayNewMessage:", name: "newMessage", object: nil)
        
        PFPush.subscribeToChannelInBackground(self.code) { succeeded, error in
            if succeeded {
                print("🚀 Successfully subscribed to channel: \(self.code).")
            } else {
                print("🆘 🚀 Failed to subscribe to channel: \(self.code) with Parse error: \n \(error)")
            }
        }
    }
    
    // Unsubscribe user
    func unsubscribeUser(fromView sender: ChatViewController) {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "newMessage", object: nil)

        PFPush.unsubscribeFromChannelInBackground(self.code) { succeeded, error in
            if succeeded {
                print("🚀 Unsubscribed from \(self.code)")
            } else {
                print("🆘 🚀 Failed to leave channel: \(self.code) with Parse error: \n \(error)")
            }
        }
    }
    
}
