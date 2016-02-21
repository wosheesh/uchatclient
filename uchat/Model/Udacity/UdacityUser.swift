//
//  UdacityUser.swift
//  On the Map
//
//  Created by Wojtek Materka on 29/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Foundation
import XCGLogger

struct UdacityUser {
    
    static var udacityKey : String? {
        willSet(userUdacityKey) {
            log.info("setting user udacity Key to \(userUdacityKey)")
        }
        didSet {
            if udacityKey != oldValue {
                log.info("Changed user Udacity key from \(oldValue) to \(udacityKey)")
            }
        }
    }
    static var firstName : String?
    static var lastName : String?
    static var channels: [Channel]?
    
    init(udacityKey: String, firstName: String, lastName: String) {
        UdacityUser.udacityKey = udacityKey
        UdacityUser.firstName = firstName
        UdacityUser.lastName = lastName
    }
    
    /* Convert JSON result from UClient login to udacityUser */
    static func udacityUserFromUserData(userData: [String:AnyObject]) -> UdacityUser {
        
        let user = UdacityUser(
            udacityKey: userData[UClient.JSONResponseKeys.UserKey] as! String,
            firstName: userData[UClient.JSONResponseKeys.FirstName] as! String,
            lastName: userData[UClient.JSONResponseKeys.LastName] as! String)
        
        return user
    }
    
//    static func updateUdacityUserFromDictionary(userData: [String:AnyObject]) {
//
//        udacityUser.mapString = userData[ParseClient.JSONResponseKeys.MapString] as? String
//        udacityUser.mediaURL = userData[ParseClient.JSONResponseKeys.MediaURL] as? String
//        udacityUser.lat = userData[ParseClient.JSONResponseKeys.Latitude] as? Double
//        udacityUser.long = userData[ParseClient.JSONResponseKeys.Longitude] as? Double
//        udacityUser.objectID = userData[ParseClient.JSONResponseKeys.ObjectID] as? String
//
//    }
    
    static func clearUdacityUser() {
        UdacityUser.udacityKey = nil
        UdacityUser.firstName = nil
        UdacityUser.lastName = nil

    }
    
    
}

