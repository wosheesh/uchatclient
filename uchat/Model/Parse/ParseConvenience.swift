//
//  ParseConvenience.swift
//  On the Map
//
//  Created by Wojtek Materka on 03/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Foundation


extension ParseClient {
    
    
    func push(message: Message, channel: Channel) {
        
        var mutableMethod : String = Methods.PushNotification
        let httpMethod : String = HttpMethods.PushNotification
        
        
        
    }
    
    

//    
//    // MARK: submitStudentLocation
//    /// Submits new StudentLocation of the current app user to the Parse StudentInformation array.
//    func submitStudentLocation(completionHandler: (success: Bool, errorString: String?) -> Void) {
//        
//        var httpMethod : String
//        
//        /* 1. Specify parameters, method and HTTP Body */
//        var mutableMethod : String = Methods.UpdateStudentLocation
//        
//        if let objectID = UserInformation.objectID {
//            mutableMethod = ParseClient.subtituteKeyInMethod(mutableMethod, key: ParseClient.URLKeys.UniqueKey, value: objectID)! // user.objectID!
//            httpMethod = ParseClient.HttpMethods.UpdateExistingUser
//        } else {
//            mutableMethod = ParseClient.subtituteKeyInMethod(mutableMethod, key: ParseClient.URLKeys.UniqueKey, value: "")!
//            httpMethod = ParseClient.HttpMethods.PostNewUser
//        }
//        
//        let jsonBody : [String : AnyObject] = [
//            ParseClient.JSONResponseKeys.UniqueKey : UserInformation.udacityKey!,
//            ParseClient.JSONResponseKeys.FirstName : UserInformation.firstName!,
//            ParseClient.JSONResponseKeys.LastName : UserInformation.lastName!,
//            ParseClient.JSONResponseKeys.MapString : UserInformation.mapString!,
//            ParseClient.JSONResponseKeys.MediaURL : UserInformation.mediaURL!,
//            ParseClient.JSONResponseKeys.Latitude : UserInformation.lat!,
//            ParseClient.JSONResponseKeys.Longitude: UserInformation.long!
//        ]
//        
//        print("Calling PARSEmethod: \(mutableMethod) with HTTPmethod: \(httpMethod)")
//        
//        /* 2. make the request */
//        taskForHTTPMethod(mutableMethod, httpMethod: httpMethod, parameters: nil, jsonBody: jsonBody) { JSONResult, error in
//            
//            /* 3. Send the desired value(s) to completion handler */
//            if let error = error {
//                if error.code == NSURLErrorTimedOut ||
//                    error.code == NSURLErrorNotConnectedToInternet {
//                    completionHandler(success: false, errorString: "Request timed out - Check your connection")
//                } else {
//                    completionHandler(success: false, errorString: "Something went wrong while trying to update your location. Try again later.")
//                }
//            } else if let _ = JSONResult[ParseClient.JSONResponseKeys.PUTResponse] as? String {
//                completionHandler(success: true, errorString: nil)
//            } else if let _ = JSONResult[ParseClient.JSONResponseKeys.POSTResponse] as? String {
//                completionHandler(success: true, errorString: nil)
//            } else {
//                completionHandler(success: false, errorString: "Could not PUT new user information")
//            }
//            
//        }
//    }
    
}