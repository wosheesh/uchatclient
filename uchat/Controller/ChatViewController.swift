//
//  ChatViewController.swift
//  uchat
//
//  Created by Wojtek Materka on 21/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit
import XCGLogger
import Parse

class ChatViewController: UIViewController {
    
    // MARK: - 🎛 Properties
    
    var channel: Channel!
    var messages: [Message] = []
    
    @IBOutlet weak var chatWall: UITableView!
    @IBOutlet weak var chatTextField: UITextField!
    
    // MARK: - 🔄 Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        log.info("Entered channel: \(channel.name)")
        
        // DEBUG 1st message:
        let msg = Message(body: "Hello there!", author: PFUser.currentUser()!)
        messages.append(msg)
        
        // Set up UI controls
        self.chatWall.rowHeight = UITableViewAutomaticDimension
        self.chatWall.estimatedRowHeight = 66.0
        self.chatWall.separatorStyle = .None
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("chatCell", forIndexPath: indexPath)
        let message = messages[indexPath.row]
        
        cell.detailTextLabel?.text = message.author.username
        cell.textLabel?.text = message.body
        cell.selectionStyle = .None
        return cell
    }
    
    
}

