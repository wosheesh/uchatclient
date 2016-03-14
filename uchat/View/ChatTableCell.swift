//
//  ChatTableCell.swift
//  uchat
//
//  Created by Wojtek Materka on 02/03/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit

class ChatTableCell: UITableViewCell {
    
    @IBOutlet weak var messageBody: UILabel!
    @IBOutlet weak var messageAuthorName: UILabel!
    @IBOutlet weak var emojiIndicator: UILabel!
    
    var timer = NSTimer()
    
    let dial = ["🕐", "🕑", "🕒", "🕓", "🕔", "🕕", "🕖", "🕗", "🕘", "🕙", "🕚", "🕛"]
    var counter = 0
    
}

extension ChatTableCell: ConfigurableCell {
    
    func configureForObject(message: Message) {
        updateIndicator(message.status)
        messageBody.text = message.body
        messageAuthorName.text = message.authorName
        
        if message.authorKey == UdacityUser.udacityKey {
            messageAuthorName.textColor = OTMColors.UGreen
        } else {
            messageAuthorName.textColor = UIColor(red: 0.722, green: 0.722, blue: 0.722, alpha: 1.00)
        }
        
    }
    
    func updateIndicator(status: Message.Status) {
        timer.invalidate()
        
        switch status {
        case .Created:
            timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "emojiDial", userInfo: nil, repeats: true)
        case .Sent:
            messageSent()
        case .Received:
            messageReceived()
        case .Lost:
            messageLost()
        }
        
    }
    
}

// MARK: - Message status update

extension ChatTableCell {
    
    func emojiDial() {
        self.emojiIndicator.text = dial[counter]
        print("counter: \(counter)")
        print(dial.count)
        if ++counter == dial.count {
            counter = 0
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

