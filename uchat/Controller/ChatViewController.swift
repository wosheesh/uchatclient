//
//  ChatViewController.swift
//  uchat
//
//  Created by Wojtek Materka on 21/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit
import XCGLogger

class ChatViewController: UITableViewController {
    
    // MARK: - 🎛 Properties
    
    var channel: Channel!
    
    // MARK: - 🔄 Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        log.info("Selected channel: \(channel.name)")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}
