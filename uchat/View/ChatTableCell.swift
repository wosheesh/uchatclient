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
    
}

extension ChatTableCell: ConfigurableCell, Emojicator {
    
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
        
        switch status {
        case .Created:
            emojiDialStart()
        case .Sent:
            messageSent()
        case .Received:
            messageReceived()
        case .Lost:
            messageLost()
        }
        
    }
    
}

