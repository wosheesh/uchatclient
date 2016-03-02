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
        print("configuring cell for message : \(message)")
        messageBody.text = message.body
        messageAuthorName.text = message.authorName
        
    }
    
}
