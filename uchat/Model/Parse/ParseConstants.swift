//
//  ParseConstants.swift
//  On the Map
//
//  Created by Wojtek Materka on 22/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Foundation

extension ParseClient {
    
    // MARK: Constants
    
    struct Constants {
        
        // MARK: API and App ID and HTTPHeaders
        static let ParseAppID : String = envDict["PARSE_APP_ID"]!
        static let ParseAppIDHTTPHeader: String = "X-Parse-Application-Id"
        
        static let ParseMasterKey : String = envDict["PARSE_MASTER_KEY"]!
        static let ParseMasterKeyHTTPHeader: String = "X-Parse-Master-Key"
        
        // MARK: URLs
        static let BaseURLSecure : String = envDict["PARSE_SERVER"]!

        // MARK: Timouts
        static let RequestTimeout : Double = 15
        static let ResourceTimeout : Double = 15
    }
    
    // MARK: Methods
    
    struct Methods {
        
        // MARK: Student Location
        static let PushNotification = "/push"
    }
    
    struct HttpMethods {
        static let PushNotification = "POST"
    }
    

    
    // MARK: Parameter key
    struct ParameterKeys {
        static let ArrayQuery = "where"
        static let LimitQuery = "limit"
        static let OrderQuery = "order"
        static let SkipQuery = "skip"
        
    }
    
    // MARK: JSON Response Keys
    
    struct JSONResponseKeys {
        
        // MARK: Student Location
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let ObjectID = "objectId"
        
        static let Results = "results"
        
        // MARK: PUT/POST Method Response
        static let POSTResponse = "createdAt"
        static let PUTResponse = "updatedAt"
    }
    
    
}
