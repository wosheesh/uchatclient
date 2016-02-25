//
//  Message.swift
//  uchat
//
//  Created by Wojtek Materka on 21/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

// TODO: Add timestamps to created, sent and received

// This struct doesn't allow editing of the messages

import UIKit
import Parse

struct Message {
    private var body: String
    private var creator: chatUser
    private var createdAt: NSDate
    
    init(body: String, creator: chatUser) {
        self.body = body
        self.creator = creator
        self.createdAt = NSDate()
    }
    
    func text() -> String! {
        return self.body
    }
    
    func author() -> chatUser! {
        return self.creator
    }
    
    func date() -> NSDate! {
        return self.createdAt
    }

    func Send(toChannel channel: Channel) {

        //TODO: throws error
        ParseClient.sharedInstance.push(self, channel: channel)

    }
    
    // MARK: - 💁 Convenience
    enum MessageError: ErrorType {
        case InvalidSyntax
        case NoBodyFound
        case NoAuthorFound
        case NoChannelFound
    }
    
    static func createFromPushNotification(userInfo: [NSObject : AnyObject]) throws -> Message {
        
        //TODO: Drop "current channel"
        
        guard let aps = userInfo["aps"] as? NSDictionary else {
            throw MessageError.InvalidSyntax
        }
        
        guard let body = aps[ParseClient.PushKeys.MessageBody] as? String else {
            throw MessageError.NoBodyFound
        }
        
        guard let authorName = userInfo[ParseClient.PushKeys.MessageAuthor] as? String else {
            throw MessageError.NoAuthorFound
        }
        
        guard let channelName = userInfo[ParseClient.PushKeys.CurrentChannel] as? String else {
            throw MessageError.NoChannelFound
        }
        
        let newChannel = Channel(name: channelName, messages: [])
        let newUser = User(username: authorName, currentChannel: newChannel)
        let message = Message(body: body, creator: newUser)
                
        return message

    }
    
    
    
}