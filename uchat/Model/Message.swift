//
//  Message.swift
//  uchat
//
//  Created by Wojtek Materka on 21/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import CoreData
import Parse

public final class Message: ManagedObject {
    @NSManaged public private(set) var body: String
    @NSManaged public private(set) var authorName: String
    @NSManaged public private(set) var authorKey: String // If want to allow students communicate directly in next ver of the app. For now it is used to distinguish messages of the current user from that of others'
    @NSManaged public private(set) var createdAt: NSDate
    @NSManaged public var receivedAt: NSDate?
    @NSManaged public private(set) var channel: Channel
    
//    init(body: String, authorName: String, authorKey: String) {
//        self.body = body
//        self.authorName = authorName
//        self.authorKey = authorKey
//        self.createdAt = NSDate()
//    }
}

extension Message: ManagedObjectType {
    public static var entityName: String {
        return "Message"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "receivedAt", ascending: false)]
    }
}


extension Message {

    func Send(toChannel channel: Channel, sender: UIViewController) {
        
        // create message body
        let jsonBody: [String: AnyObject] = [
            "channels" : [channel.code],
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
    
//    static func createFromPushNotification(userInfo: [NSObject : AnyObject]) throws -> Message {
//        
//        guard let aps = userInfo["aps"] as? NSDictionary else {
//            throw MessageError.InvalidSyntax
//        }
//        
//        guard let body = aps[ParseClient.PushKeys.MessageBody] as? String else {
//            throw MessageError.BodyNotFound
//        }
//        
//        guard let authorName = userInfo[ParseClient.PushKeys.MessageAuthor] as? String else {
//            throw MessageError.AuthorUsernameNotFound
//        }
//        
//        guard let authorKey = userInfo[ParseClient.PushKeys.AuthorKey] as? String else {
//            throw MessageError.KeyNotFound
//        }
//
//        return Message(body: body, authorName: authorName, authorKey: authorKey)
//
//    }
    
    
    
}