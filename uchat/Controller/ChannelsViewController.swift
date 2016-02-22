//
//  ChannelsViewController.swift
//  uchat
//
//  Created by Wojtek Materka on 21/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

//TODO: Sections in the table
//TODO: subscribe and unsubsribe from channels - https://www.udacity.com/catalog-api
//TODO: persist subscribed channels
//TODO: Add logout

import UIKit

class ChannelsViewController: UITableViewController {
    
    //MARK: - 🎛 Properties
    
    //start with a general channel as default
    var channels = [Channel(name: "General", messages: [])]
    
    //MARK: - 🔄 Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add user's channels
        if let userChannels = UdacityUser.channels {
            channels.appendContentsOf(userChannels)
        }
        
        // setup the current user's nickname
//        let currentUser = PFUser.currentUser()!
//        if let firstName = UdacityUser.firstName,
//            let lastName = UdacityUser.lastName {
//                currentUser.username = firstName + " " + lastName
//        }
        
        print("username: \(UdacityUser.firstName)")

    }
    
    //MARK: - ➡️ Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "enterChannel" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let channel = channels[indexPath.row]
                let controller = segue.destinationViewController as! ChatViewController
                controller.channel = channel
                controller.navigationItem.leftItemsSupplementBackButton = true
                
            }
        }
    }
    
    //MARK: - 📄 TableViewController
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.channels.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("channelCell", forIndexPath: indexPath)
        
        let channel = channels[indexPath.row]
        cell.textLabel?.text = channel.name
        
        return cell
    }
    
}
