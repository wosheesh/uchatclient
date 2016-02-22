//
//  Message.swift
//  uchat
//
//  Created by Wojtek Materka on 21/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

// TODO: Add timestamp

// This struct doesn't allow editing of the messages
struct Message {
    private var body: String
    private var creator: User
    private var createdAt: NSDate {
        return NSDate()
    }
    
    init(body: String, creator: User) {
        self.body = body
        self.creator = creator
    }
    
    func text() -> String! {
        return self.body
    }
    
    func author() -> User! {
        return self.creator
    }
    
    func date() -> NSDate! {
        return self.createdAt
    }
    
}