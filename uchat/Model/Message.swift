//
//  Message.swift
//  uchat
//
//  Created by Wojtek Materka on 21/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import CoreData

public final class Message: ManagedObject {
    @NSManaged public private(set) var id: String
    @NSManaged public private(set) var body: String
    @NSManaged public private(set) var authorName: String
    @NSManaged public private(set) var authorKey: String
    @NSManaged public private(set) var createdAt: NSDate
    @NSManaged public private(set) var receivedAt: NSDate?
    @NSManaged public private(set) var channel: Channel
    
    public static func insertIntoContext(moc: NSManagedObjectContext, body: String, authorName: String, authorKey: String, createdAt: NSDate, receivedAt: NSDate?, channel: Channel) -> Message {
        print("💌 packaging the message 1")
        let message: Message = moc.insertObject()
        print("💌 packaging the message 2")
        message.id = NSUUID().UUIDString
        print("💌 packaging the message 3")
        message.body = body
        message.authorName = authorName
        message.authorKey = authorKey
        message.channel = channel
        message.createdAt = createdAt
        message.receivedAt = receivedAt
        return message
    }
    
    public static func insertIntoContextAndSend(moc: NSManagedObjectContext, body: String, authorName: String, authorKey: String, createdAt: NSDate, receivedAt: NSDate?, channel: Channel, sender: UIViewController) -> Message {
        
        let message = insertIntoContext(moc, body: body, authorName: authorName, authorKey: authorKey, createdAt: createdAt, receivedAt: nil, channel: channel)
        
        message.Send(toChannel: channel, sender: sender)
        
        return message
    }
    
}

extension Message: ManagedObjectType {
    public static var entityName: String {
        return "Message"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "receivedAt", ascending: true)]
    }
    
    public static func findOrFetchMessage(withId id: String, inContext moc: NSManagedObjectContext) -> Message? {
        let predicate = NSPredicate(format: "id == %@", id)
        let message = findOrFetchInContext(moc, matchingPredicate: predicate)
        return message
    }
    
}

// MARK: - Interface with Parse

import Parse

extension Message {

    func Send(toChannel channel: Channel, sender: UIViewController) {
        // create message body
        let jsonBody: [String: AnyObject] = [
            "channels" : [channel.code],
            "data": [
                ParseClient.PushMessage.Id: self.id,
                ParseClient.PushMessage.Body: self.body,
                ParseClient.PushMessage.Authorname: self.authorName,
                ParseClient.PushMessage.AuthorKey: self.authorKey,
                ParseClient.PushMessage.CreatedAt: self.createdAt.dateToString()
            ]
        ]

        // send the message with completion block
        ParseClient.sharedInstance.push(jsonBody) { success, errorString in
            if !success { simpleAlert(sender, message: errorString!) }
            //TODO: recover from send failures
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