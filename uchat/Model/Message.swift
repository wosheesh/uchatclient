//
//  Message.swift
//  uchat
//
//  Created by Wojtek Materka on 21/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

// TODO: Add timestamps to created, sent and received

// This struct doesn't allow editing of the messages
import Foundation
import UIKit

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

    func sendMessage(toChannel channel: String) {
        
//        let data = ["author" : self.author().username!]
//        let tags = ["key": "Channel", "relation": "=", "value": channel]
//        
////        [
////            "author" : self.author().username!,
////            "tags" : ["key": "Channel", "relation": "=", "value": channel]
////        ]
//        
////        OneSignal.pushNotification(withBody: self.body, data: data, tags: tags)

    }
    
}