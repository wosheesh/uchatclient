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
        static let PushNotification = "/push"
    }
    
    struct HttpMethods {
        static let PushNotification = "POST"
    }
    
    // MARK: PushNotifications Keys
    
    struct PushKeys {
        static let Type = "Type"
        static let Channels = "channels"
        static let MessageAuthor = "Author"
        static let MessageBody = "alert"
        static let AuthorKey = "AuthorKey"
    }
    
    
    
}
