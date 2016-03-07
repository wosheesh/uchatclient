//
//  ChannelsViewController.swift
//  uchat
//
//  Created by Wojtek Materka on 21/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

//TODO: Change the segue for logout

import UIKit
import CoreImage
import CoreData

class ChannelsViewController: UITableViewController, ManagedObjectContextSettable, SegueHandlerType, ProgressViewPresenter {
    
    // MARK: - 🎛 Properties

    var managedObjectContext: NSManagedObjectContext!
    
    @IBOutlet var channelsTable: UITableView!
    
    var messageFrame = UIView()
    
    enum SegueIdentifier: String {
        case EnterChannel = "EnterChannel"
        case Logout = "Logout"
    }
    
    //start with a general channel as default
    var channels: [Channel] = [] // Channel(code: "0", name: "General", tagline: "Channel open to all students")
    
    //MARK: - 🔄 Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
//        showProgressView("Checking the catalogue")
        UClient.sharedInstance().updateUdacityCourseCatalogue() { result in
            switch result {
            case .Success(_):
                print("Setting up Table Data Source for Channels")
                self.setupTableView()
                print("Updating the channels list with catalogue...")
                self.updateChannels()
                
//                self.hideProgressView()
            case .Failure(let error):
//                self.hideProgressView()
                switch error {
                case .ConnectionError:
                    simpleAlert(self, message: "There was an issue with your connection. Please try again")
                case .JSONParseError:
                    simpleAlert(self, message: "I couldn't parse the data from Udacity server...")
                case .NoDataReceived:
                    simpleAlert(self, message: "I didn't receive any data from Udacity server... maybe try again?")
                default:
                    simpleAlert(self, message: "Something went wrong while trying to access Udacity server... maybe try again?")
                }
            }
        }
        
    }
    
    @IBAction func logoutButtonTouchUp(sender: AnyObject) {
        UdacityUser.logout() { result in
            switch result {
            case .Success(_):
                // if current user has logged out, set the current NSManagedContext to nil
                self.managedObjectContext = nil
                self.performSegue(SegueIdentifier.Logout)
            case .Failure(let error):
                switch error {
                case .ConnectionError:
                    simpleAlert(self, message: "Couldn't log-out. There was an issue with your connection. Please try again")
                default:
                    simpleAlert(self, message: "Something went wrong while trying to logout... maybe try again?")
                }
            }
        }
    }
    // MARK: - 🐵 Helpers
    
    func updateChannels() {
        
        var channels: [Channel] = []

        // Check if the user has any course enrollments
        guard let coursesEnrolled = UdacityUser.enrolledCourses else {
            print("User has no courses enrolled. Only General channel available")
            return
        }
        
        //TODO: Add General channel to db

        // Match user's courses with the catalogue
        let courseCatalogue = NSArray(contentsOfFile: UClient.sharedInstance().courseCatalogueFilePath) as! [[String : AnyObject]]
        let coursesMatching = courseCatalogue.filter { course in
            coursesEnrolled.contains(course[UClient.JSONResponseKeys.CourseKeyCatalogue] as! String)
        }

        print("Found \(coursesMatching.count) matching courses in the catalogue.")

        //Update the channels in coredata
        for course in coursesMatching {
            let channelCode = course[UClient.JSONResponseKeys.CourseKeyCatalogue] as! String
            let channelName = course[UClient.JSONResponseKeys.CourseTitle] as! String
            let channelTagline = course[UClient.JSONResponseKeys.CourseSubtitle] as! String
            let imagePathOnline = course[UClient.JSONResponseKeys.CourseImage] as? String
            
            managedObjectContext.performChanges {
                // create or fetch channel object
                let channel = Channel.findOrCreateChannel(channelCode, name: channelName, tagline: channelTagline, picturePath: imagePathOnline, inContext: self.managedObjectContext)
                print("channel.localpicturename = \(channel.localPictureName)")
                
                if channel.localPictureName == nil {
                    
                    channel.localPictureName = channel.code + ".jpg"
                }
                
            }
            
            
        
//            let predicate = NSPredicate(format: "code == %@", channelCode)
//            guard let channel = Channel.findOrFetchInContext(managedObjectContext, matchingPredicate: predicate) else {
//                fatalError("Couldn't find channel we just created")
//            }
//            
//            print("channel.localpicturename = \(channel.localPictureName)")
//            
//            channel.localPictureName = "ud509.jpg"
            
//            if channel.localPictureName == nil {
//                // if a channel doesn't have a local picture download new one or set a default
//                if let imageUrl = imagePathOnline where imageUrl != "" {
//                    PictureCache().downloadPicture(imageUrl) { result in
//                        
//                        switch result {
//                        case .Success(let picture):
//                            channel.updatePicture(picture as? UIImage, inContext: self.managedObjectContext)
//                            
//                        case .Failure(_):
//                            channel.updatePicture(nil, inContext: self.managedObjectContext)
//                        }
//                        
//                    }
//                } else {
//                    channel.updatePicture(nil, inContext: self.managedObjectContext)
//                }
//            } else {
//                // load picture if it is available locally
//                channel.updatePicture(PictureCache().pictureWithIdentifier(channel.localPictureName!), inContext: self.managedObjectContext)
//            }
        
        }
        

    }





    // MARK: - ➡️ Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segueIdentifierForSegue(segue) {
        case .EnterChannel:
            guard let vc = segue.destinationViewController as? ChatViewController else { fatalError("Wrong view controller type") }
            guard let channel = dataSource.selectedObject else { fatalError("Showing ChatViewController, but no selected row?") }
            print("Opening channel : \(channel)")
            vc.managedObjectContext = managedObjectContext
            vc.channel = channel
        case .Logout:
            guard let rvc = segue.destinationViewController as? LoginViewController else { fatalError("Wrong view controller type") }
            rvc.managedObjectContext = managedObjectContext
        }
    }

    // MARK: Private
    
    private typealias Data = FetchedResultsDataProvider<ChannelsViewController>
    private var dataSource: TableViewDataSource<ChannelsViewController, Data, ChannelTableCell>!
    
    private func setupTableView() {
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
    // MARK: - 🎩 DataProviderDelegate & DataSourceDelegate
    
extension ChannelsViewController: DataProviderDelegate {
    func dataProviderDidUpdate(updates: [DataProviderUpdate<Channel>]?) {
        dataSource.processUpdates(updates)
    }
}

extension ChannelsViewController: DataSourceDelegate {
    func cellIdentifierForObject(object: Channel) -> String {
        return "ChannelCell"
    }
}
    

