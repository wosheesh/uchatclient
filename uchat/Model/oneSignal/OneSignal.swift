//
//  OneSignal.swift
//  uchat
//
//  Created by Wojtek Materka on 23/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

//TODO: if the channel is empty then OneSignal fails to send the message

import UIKit

let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
let oneSignal = appDelegate.oneSignal

extension OneSignal {
    
    static func pushNotification(withBody body: String!, data: [String : AnyObject]?, tags: [String : AnyObject]?) {
        
        var notification = ["contents": ["en": "\(body)"]] as [NSObject : AnyObject]
        if data != nil {
            notification["data"] = data
        }
        if tags != nil {
            notification["tags"] = tags
        }
        
        oneSignal!.postNotification(notification)

//        oneSignal!.IdsAvailable({ (userId, pushToken) in
//            NSLog("UserId:%@", userId)
//            if (pushToken != nil) {
//                notification["include_player_ids"] = [userId]
//                print("Trying to send notification: ")
//                print(notification)
//                oneSignal!.postNotification(notification)
//            }
//        });
    }
    
    static func tagUser(withTag tag: String, value: String) {
        oneSignal!.sendTag(tag, value: value)
    }
    
    static func deleteUserTag(tag: String) {
        oneSignal!.deleteTag(tag)
    }
    
    // MARK: - Helpers
//    static func generateTags(key: String, 
    
//    static func uTagUser
    

}
