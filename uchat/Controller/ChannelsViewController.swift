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
import CoreImage
import CoreData

class ChannelsViewController: UITableViewController, ManagedObjectContextSettable {
    
    // MARK: - 🎛 Properties

    var managedObjectContext: NSManagedObjectContext!
    
    @IBOutlet var channelsTable: UITableView!
    
    //start with a general channel as default
    var channels: [Channel] = [] // Channel(code: "0", name: "General", tagline: "Channel open to all students")
    
    //MARK: - 🔄 Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        // update the course catalogue
        UClient.sharedInstance().updateUdacityCourseCatalogue() { success, errorString in
            if success {
                print("Updating the channels list with catalogue...")
                self.setupTableView()
                
            } else {
                print(errorString)
            }
        }

    }
    
    // MARK: - 🐵 Helpers
    
//    func updateChannels() {
//        
//        // Check if the user has any course enrollments
//        guard let coursesEnrolled = UdacityUser.enrolledCourses else {
//            print("User has no courses enrolled. Only General channel available")
//            return
//        }
//        
//        // Match user's courses with the catalogue
//        let courseCatalogue = NSArray(contentsOfFile: UClient.sharedInstance().courseCatalogueFilePath) as! [[String : AnyObject]]
//        let coursesMatching = courseCatalogue.filter { course in
//            coursesEnrolled.contains(course[UClient.JSONResponseKeys.CourseKeyCatalogue] as! String)
//        }
//        
//        print("found \(coursesMatching.count ) matching courses.")
//        
//        
//        //TODO: Move this to channel init from catalogue data
//        
//        //Update the channels array
//        for course in coursesMatching {
//            let channelCode = course[UClient.JSONResponseKeys.CourseKeyCatalogue] as! String
//            let channelName = course[UClient.JSONResponseKeys.CourseTitle] as! String
//            let channelTagline = course[UClient.JSONResponseKeys.CourseSubtitle] as! String
//            let imagePathOnline = course[UClient.JSONResponseKeys.CourseImage] as! String
//            
//            
////            var newChannel = Channel(code: channelCode, name: channelName, tagline: channelTagline)
//            let localPictureName = PictureCache().pathForIdentifier(newChannel.code + ".jpg")
//            
//            // If there's an image already downloaded add its path and append new channel
//            guard !NSFileManager.defaultManager().fileExistsAtPath(localPictureName) else {
//                newChannel.picturePath = localPictureName
//                channels.append(newChannel)
//                continue
//            }
//                
//            // Check if the catalogue has an image url available
//            if let pictureUrl = NSURL(string: imagePathOnline)  {
//                print("downloading: \(pictureUrl)")
//                
//                do {
//                    try PictureCache().downloadPictureToDocuments(pictureUrl, filename: newChannel.code + ".jpg") { success, errorString in
//                        if success {
//                            newChannel.picturePath = localPictureName
//                            self.applyFilters(localPictureName)
//                            self.channelsTable.reloadData()
//                        } else {
//                            print(errorString)
//                        }
//                    }
//                } catch PictureCache.Errors.NoFileFoundAtURL {
//                    print("No image path specified in the catalogue, will use the default image")
//                } catch {
//                    print("Error while downloading picture for channel")
//                }
//            }
//            
//            
//            
//            // append new channel even if no file for image found
//            channels.append(newChannel)
//            
//
//        }
//        
//    }
    
//    func applyFilters(fileURLString: String) {
//        
//        let fileURL = NSURL(fileURLWithPath: fileURLString)
//        
//        guard var beginImage = CIImage(contentsOfURL: fileURL) else {
//            print("couldn't find a picture")
//            return
//        }
//        
//        beginImage = blur(5.0)(beginImage)
//        beginImage = sepia(0.5)(beginImage)
//            
////            let context = CIContext(options: nil)
//        // https://developer.apple.com/library/mac/documentation/GraphicsImaging/Conceptual/CoreImaging/ci_tasks/ci_tasks.html#//apple_ref/doc/uid/TP30001185-CH3-SW19
//        let myEAGLContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
//        let options = [kCIContextWorkingColorSpace : NSNull()]
//        let eagContext = CIContext(EAGLContext: myEAGLContext, options: options)
//        let cgimg = eagContext.createCGImage(beginImage, fromRect: beginImage.extent)
//        
//        let newImage = UIImage(CGImage: cgimg)
//        
//        let fileName = fileURL.lastPathComponent
//        
//        print("Saving filtered image as: \(fileName)")
//        
//        PictureCache().storePicture(newImage, withIdentifier: fileName!)
//        
//    }
    

    // MARK: Private
    private typealias Data = FetchedResultsDataProvider<ChannelsViewController>
    private var dataSource: TableViewDataSource<ChannelsViewController, Data, ChannelTableCell>!
    
    private func setupTableView() {
        channelsTable.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200

        let request = Channel.sortedFetchRequest
        request.returnsObjectsAsFaults = false
        print("running fetch request on Channels")
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        print("configuring dataProvider for channelsTable")
        let dataProvider = FetchedResultsDataProvider(fetchedResultsController: frc, delegate: self)
        print("configuring dataSource for channelsTable")
        dataSource = TableViewDataSource(tableView: channelsTable, dataProvider: dataProvider, delegate: self)
        
    }
    
}
    
    
    // MARK: - ➡️ Segues
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "enterChannel" {
//            if let indexPath = self.tableView.indexPathForSelectedRow {
//                
//                let channel = channels[indexPath.row]
//                let controller = segue.destinationViewController as! ChatViewController
//                controller.channel = channel
//                controller.navigationItem.leftItemsSupplementBackButton = true
//                
//            }
//        }
//    }
    
    // MARK: - 🎩 DataProviderDelegate
    
extension ChannelsViewController: DataProviderDelegate {
    func dataProviderDidUpdate(updates: [DataProviderUpdate<Channel>]?) {
        dataSource.processUpdates(updates)
    }
}

extension ChannelsViewController: DataSourceDelegate {
    func cellIdentifierForObject(object: Channel) -> String {
        return "channelCell"
    }
}
    

