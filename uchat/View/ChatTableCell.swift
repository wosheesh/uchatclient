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
}

extension ChatTableCell: ConfigurableCell {
    
    func configureForObject(message: Message) {
        messageBody.text = message.body
        messageAuthorName.text = message.authorName
        
        if message.authorKey == UdacityUser.udacityKey {
            messageAuthorName.textColor = OTMColors.UGreen
        } else {
            messageAuthorName.textColor = UIColor(red: 0.722, green: 0.722, blue: 0.722, alpha: 1.00)
        }
        
    }
    
}
