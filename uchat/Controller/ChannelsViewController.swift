//
//  ChannelsViewController.swift
//  uchat
//
//  Created by Wojtek Materka on 21/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

//TODO: add all channels - https://www.udacity.com/catalog-api
//TODO: persist subscribed channels
//TODO: Add logout

import UIKit


class ChannelsViewController: UITableViewController {
    
    //MARK: - 🎛 Properties
    
    //start with a general channel as default
    var channels = [Channel(name: "General")]
    
    //MARK: - 🔄 Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        UClient.sharedInstance().downloadUdacityCourseCatalogue() { success, errorString in
            if success {
                print("catalogue downloaded succesfully")
            } else {
                print(errorString)
            }
        }

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
