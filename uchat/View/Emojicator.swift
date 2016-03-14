//
//  Emojicator.swift
//  uchat
//
//  Created by Wojtek Materka on 14/03/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Foundation
import UIKit

protocol Emojicator {
    weak var emojiIndicator: UILabel! {get}
}

extension Emojicator {
    func emojiDialStart() {
        let dial = ["🕐", "🕑", "🕒", "🕓", "🕔", "🕕", "🕖", "🕗", "🕘", "🕙", "🕚", "🕛"]
        
        var counter = 0
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
        
        while counter < dial.count {
            dispatch_after(time, dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
                self.emojiIndicator.text = dial[counter]
            }
            counter++
            if counter == dial.count { counter = 0 }
        }


    }
    
    func messageSent() {
        emojiIndicator.text = "📮"
    }
    
    func messageReceived() {
        emojiIndicator.text = "📥"
    }
    
    func messageLost() {
        emojiIndicator.text = "😳"
    }
}
