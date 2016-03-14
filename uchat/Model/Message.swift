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
    @NSManaged public private(set) var statusValue: Int
    
    public var status: Status {
        get { return Status(rawValue: statusValue)! }
        set { statusValue = newValue.rawValue }
    }
    
    public enum Status: Int {
        case Created = 1, Sent, Received, Lost
    }
    
    public static func insertIntoContext(moc: NSManagedObjectContext, body: String, authorName: String, authorKey: String, createdAt: NSDate, receivedAt: NSDate?, channel: Channel) -> Message {
        let message: Message = moc.insertObject()
        message.id = NSUUID().UUIDString
        message.body = body
        message.authorName = authorName
        message.authorKey = authorKey
        message.channel = channel
        message.createdAt = createdAt
        message.receivedAt = receivedAt
        message.status = .Created
        return message
    }
    
    public static func insertIntoContextAndSend(moc: NSManagedObjectContext, body: String, channel: Channel, sender: UIViewController) -> Message {
        
        let authorName = UdacityUser.username!
        let authorKey = UdacityUser.udacityKey!
        let createdAt = NSDate()
        
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
    
    /// Translates the object's parameters into json for push notification.
    func Send(toChannel channel: Channel, sender: UIViewController) {
        // create message body
        let jsonBody: [String: AnyObject] = [
            ParseClient.PushMessage.Channels: [channel.code],
            "data": [
                ParseClient.PushMessage.Id: self.id,
                ParseClient.PushMessage.Body: self.body,
                ParseClient.PushMessage.Channels: [channel.code],
                ParseClient.PushMessage.Authorname: self.authorName,
                ParseClient.PushMessage.AuthorKey: self.authorKey,
                ParseClient.PushMessage.CreatedAt: self.createdAt.dateToString()
            ]
        ]

        // send the message with completion block
        ParseClient.sharedInstance.push(jsonBody) { success, errorString in
            if success {
                self.status = .Sent
            } else {
                self.status = .Lost
                simpleAlert(sender, message: errorString!)
            }
            //TODO: allow to resend .Lost messages
        }
    }
    
    enum MessageError: ErrorType {
        case InvalidSyntax
        case IdNotFound
        case KeyNotFound
        case BodyNotFound
        case AuthorNameNotFound
        case CreationDateNotFound
        case ChannelIdIncorrect
        case ChannelIdNotFound
    }
    
    /// This is the main engine for parsing an incoming message into a Message object. The function checks for the validity of syntax, channel corectness and also interprets if the message was sent by the current user or other users. It will return nil if the incoming message was sent to a different channel to the currently subscribed or if we failed to create a new Message in context.
    ///  - Returns: Message?
    static func createFromPushNotification(userInfo: [NSObject : AnyObject], inContext context: NSManagedObjectContext, currentChannel: Channel) throws {
        
        guard let aps = userInfo["aps"] as? NSDictionary else { throw MessageError.InvalidSyntax }
        guard let channelCodes = userInfo[ParseClient.PushMessage.Channels] as? [String] else { throw MessageError.ChannelIdNotFound }
        
        // if for some reason we received a message that doesn't match current view's channel
        // just discard it. We could add it to a channel if user is subscribed to that channel
        // but that's a different UX. In this version the app allows sending only in currently
        // subscribed channel, and there can only be one channel subscribed at a time.
        // However this implementation makes it relatively easy to extend to create groups, etc.
        if !channelCodes.contains(currentChannel.code) { throw MessageError.ChannelIdIncorrect }
        
        guard let id = userInfo[ParseClient.PushMessage.Id] as? String else { throw MessageError.IdNotFound }
        
        // Check if this is a message we have sent. If not treat it as someone else's message and add it to context. If yes, update the existing message's receivedAt property.
        if let sentMessage = Message.findOrFetchMessage(withId: id, inContext: context) {
            print("🔂 Received a message sent by the current user. Updating receivedAt:")
            context.performChanges { sentMessage.receivedAt = NSDate() }
            return
        }
        
        guard let body = aps[ParseClient.PushMessage.Body] as? String else { throw MessageError.BodyNotFound }
        guard let authorName = userInfo[ParseClient.PushMessage.Authorname] as? String else { throw MessageError.AuthorNameNotFound }
        guard let authorKey = userInfo[ParseClient.PushMessage.AuthorKey] as? String else { throw MessageError.KeyNotFound }
        guard let createdAt = userInfo[ParseClient.PushMessage.CreatedAt] as? String else { throw MessageError.CreationDateNotFound }

        
        // If we got this far, it means this is a new message. Add it to the channel.
        context.performChanges {
            let newMessage = Message.insertIntoContext(context, body: body, authorName: authorName, authorKey: authorKey, createdAt: createdAt.stringToDate(), receivedAt: NSDate(), channel: currentChannel)
            print(newMessage)
        }
        
    }
    
    
    
}