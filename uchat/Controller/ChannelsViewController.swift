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
    
    // MARK: - 🎛 Properties
    
    //start with a general channel as default
    var channels = [Channel(name: "General", tagline: "Channel open to all students")]
    
    //MARK: - 🔄 Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        // update the course catalogue
        UClient.sharedInstance().updateUdacityCourseCatalogue() { success, errorString in
            if success {
                print("Updating the channels list with catalogue...")
                self.updateChannels()
            } else {
                print(errorString)
            }
        }

    }
    
    // MARK: - 🐵 Helpers
    
    func updateChannels() {
        
        // Check if the user has any course enrollments
        guard let coursesEnrolled = UdacityUser.enrolledCourses else {
            print("User has no courses enrolled. Only General channel available")
            return
        }
        
        // Match user's courses with the catalogue
        let courseCatalogue = NSArray(contentsOfFile: UClient.sharedInstance().courseCatalogueFilePath) as! [[String : AnyObject]]
        let coursesMatching = courseCatalogue.filter { course in
            coursesEnrolled.contains(course[UClient.JSONResponseKeys.CourseKeyCatalogue] as! String)
        }
        
        print("found \(coursesMatching.count ) matching courses.")
        
        //Update the channels array
        for course in coursesMatching {
            let newChannel = Channel(name: course[UClient.JSONResponseKeys.CourseTitle] as! String,
                tagline: course[UClient.JSONResponseKeys.CourseSubtitle] as! String)
            
            channels.append(newChannel)
        }
    }
    
    // MARK: - ➡️ Segues
    
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
    
    // MARK: - 📄 TableViewController
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.channels.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("channelCell", forIndexPath: indexPath) as! ChannelTableCell
        
        let channel = channels[indexPath.row]
        cell.courseTitleLabel.text = channel.name
        cell.courseSubtitleLabel.text = channel.tagline
        
        
        return cell
    }
    
}
