//
//  ParseConstants.swift
//  On the Map
//
//  Created by Wojtek Materka on 22/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Foundation

extension ParseClient {
    
    // MARK: - Constants
    
    struct Environment {
        static let PARSE_APP_ID: String = envDict["PARSE_APP_ID"]!
        static let PARSE_MASTER_KEY: String = envDict["PARSE_MASTER_KEY"]!
        static let PARSE_SERVER: String = envDict["PARSE_SERVER"]!
        static let PARSE_CLIENT_KEY: String = envDict["PARSE_CLIENT_KEY"]!

    }
    
    struct Constants {
        // MARK: API and App ID and HTTPHeaders
        static let ParseAppID : String = Environment.PARSE_APP_ID
        static let ParseAppIDHTTPHeader: String = "X-Parse-Application-Id"
        static let ParseMasterKey : String = Environment.PARSE_MASTER_KEY
        static let ParseMasterKeyHTTPHeader: String = "X-Parse-Master-Key"
        
        // MARK: URLs
        static let BaseURLSecure : String = Environment.PARSE_SERVER

        // MARK: Timouts
        static let RequestTimeout : Double = 15
        static let ResourceTimeout : Double = 15
    }
    
    // MARK: - Methods
    
    struct Methods {
        static let PushNotification = "/push"
    }
    
    struct HttpMethods {
        static let PushNotification = "POST"
    }
    
    // MARK: - PushNotifications Keys
    
    struct PushMessage {
        static let Id = "id"
        static let Channels = "channels"
        static let Authorname = "authorname"
        static let Body = "alert"
        static let AuthorKey = "authorKey"
        static let CreatedAt = "createdAt"
    }
    
    
    
}
