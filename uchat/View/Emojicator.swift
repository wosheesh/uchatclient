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
        
        for hour in dial {
            emojiIndicator.text = hour
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
