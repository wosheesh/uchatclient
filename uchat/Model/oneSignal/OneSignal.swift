//
//  OneSignal.swift
//  uchat
//
//  Created by Wojtek Materka on 23/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit

let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
let oneSignal = appDelegate.oneSignal

extension OneSignal {
    
    static func pushNotification(withBody body: String!, data: [String : String]?) {
        
        var notification = ["contents": ["en": "\(body)"]] as [NSObject : AnyObject]
        if data != nil {
            notification["data"] = data
        }

        oneSignal!.IdsAvailable({ (userId, pushToken) in
            NSLog("UserId:%@", userId)
            if (pushToken != nil) {
                notification["include_player_ids"] = [userId]
                oneSignal!.postNotification(notification)
            }
        });
    }
    
    static func tagUser(withTag tag: String, value: String) {
        oneSignal!.sendTag(tag, value: value)
    }
    
    static func deleteUserTag(tag: String) {
        oneSignal!.deleteTag(tag)
    }
    
//    static func uTagUser
    

}
