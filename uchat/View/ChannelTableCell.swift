//
//  ChannelTableCell.swift
//  uchat
//
//  Created by Wojtek Materka on 29/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit

class ChannelTableCell: UITableViewCell {
    
    @IBOutlet weak var courseTitleLabel: UILabel!
    @IBOutlet weak var courseSubtitleLabel: UILabel!
    @IBOutlet weak var courseBackgroundPicture: UIImageView!
    
    
}

extension ChannelTableCell: ConfigurableCell {
    
    func configureForObject(channel: Channel) {
        courseTitleLabel.text = channel.name
        courseSubtitleLabel.text = channel.tagline
        
        //TODO: Picture background
        
    }
    
}
