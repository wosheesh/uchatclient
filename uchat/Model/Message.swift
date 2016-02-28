//
//  Message.swift
//  uchat
//
//  Created by Wojtek Materka on 21/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit
import Parse

struct Message {
    let body: String
    let authorName: String
    let authorKey: String // If want to allow students communicate directly in next ver of the app. For now it is used to distinguish messages of the current user from that of others'
    let createdAt: NSDate
    var receivedAt: NSDate?
    
    init(body: String, authorName: String, authorKey: String) {
        self.body = body
        self.authorName = authorName
        self.authorKey = authorKey
        self.createdAt = NSDate()
    }
    

    func Send(toChannel channel: Channel, sender: UIViewController) {
        
        // create message body
        let jsonBody: [String: AnyObject] = [
            "channels" : [channel.name],
            "data": [
                ParseClient.PushKeys.MessageBody: self.body,
                ParseClient.PushKeys.MessageAuthor: self.authorName,
                ParseClient.PushKeys.AuthorKey: self.authorKey
            ]
            
        ]

        // send the message with completion block
        ParseClient.sharedInstance.push(jsonBody) { success, errorString in
            if !success { simpleAlert(sender, message: errorString!) }
        }
    }
    
    enum MessageError: ErrorType {
        case InvalidSyntax
        case KeyNotFound
        case BodyNotFound
        case AuthorUsernameNotFound
    }
    
    static func createFromPushNotification(userInfo: [NSObject : AnyObject]) throws -> Message {
        
        guard let aps = userInfo["aps"] as? NSDictionary else {
            throw MessageError.InvalidSyntax
        }
        
        guard let body = aps[ParseClient.PushKeys.MessageBody] as? String else {
            throw MessageError.BodyNotFound
        }
        
        guard let authorName = userInfo[ParseClient.PushKeys.MessageAuthor] as? String else {
            throw MessageError.AuthorUsernameNotFound
        }
        
        guard let authorKey = userInfo[ParseClient.PushKeys.AuthorKey] as? String else {
            throw MessageError.KeyNotFound
        }

        return Message(body: body, authorName: authorName, authorKey: authorKey)

    }
    
    
    
}