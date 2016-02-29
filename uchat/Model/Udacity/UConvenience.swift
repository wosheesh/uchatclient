//
//  UConvenience.swift
//  On the Map
//
//  Created by Wojtek Materka on 03/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Foundation

extension UClient {
    
    // MARK: Authenticate
    /// Authenticate with Udacity API with email and password, pull user data and update UserInformation
    func authenticateWithUserCredentials(email: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        if email.isEmpty {
            completionHandler(success: false, errorString: "Please enter your email.")
        } else if password.isEmpty {
            completionHandler(success: false, errorString: "Please enter your password.")
        } else {
            
            getSessionID(email, password: password, access_token: nil) { (success, sessionID, userID, errorString) in
                
                if success {
                    
                    /* get user data */
                    self.getUserDataWithUserID(userID!) { (success, userData, errorString) in
                        
                        if success {
                            
                            _ = UdacityUser(initCurrentUserFromData: userData!)

                            completionHandler(success: success, errorString: errorString) // self.getUserDataWithUserID(userID!)
                            
                        } else {
                            completionHandler(success: success, errorString: errorString) // self.getUserDataWithUserID(userID!)
                        }
                    }
                } else {
                    completionHandler(success: success, errorString: errorString) // getSessionID
                }
            }
        }
    }
    
    /// Returns Udacity user data identified by userID through completion handler
    func getUserDataWithUserID(userID: String, completionHandler: (success: Bool, userData: [String:AnyObject]?, errorString: String?) -> Void) {
        
        if userID.isEmpty {
            completionHandler(success: false, userData: nil, errorString: "UserID not provided or empty")
        } else {
            
            /* 1. Specify methods (if has {key}) */
            var mutableMethod : String = Methods.UdacityUserData
            mutableMethod = UClient.subtituteKeyInMethod(mutableMethod, key: UClient.URLKeys.UserId, value: userID)!
            
            /* 2. Make the request */
            taskForGETMethod(mutableMethod, concatenate: true) { JSONResult, error in
                
                /* 3. send the results to completionHandler */
                
                if let error = error {
                    print(error)
                    /* catching the timeout error */
                    if error.code == NSURLErrorTimedOut {
                        completionHandler(success: false, userData: nil, errorString: "Cannot connect to Udacity server. Please check your connection.")
                    } else {
                        completionHandler(success: false, userData: nil, errorString: "There was an error establishing a session with Udacity server. Please try again later.")
                    }
                } else if let userData = JSONResult[UClient.JSONResponseKeys.UserResults] as? [String : AnyObject] {
                    
                    
                    completionHandler(success: true, userData: userData, errorString: nil)
                } else {
                    completionHandler(success: false, userData: nil, errorString: "Could not parse getUserDataWithUserID")
                }
            }
        }
    }
    
    /// Uses email and password to create a session with Udacity.
    func getSessionID(email: String?, password: String?, access_token: String?, completionHandler: (success: Bool, sessionID: String?, userID: String?, errorString: String?) -> Void) {
        
        var jsonBody : [String : AnyObject]?
        
        /* 1. Specify HTTP Body */
        if let email = email {
            if let password = password {
                jsonBody = [
                    "udacity": [
                        UClient.JSONBodyKeys.Username: email as String!,
                        UClient.JSONBodyKeys.Password: password as String!
                    ]
                ]
            }
        } else if let access_token = access_token {
            jsonBody = [
                "facebook_mobile" : [
                    "access_token": access_token as String!
                ]
            ]
        }
        
        /* 2. Make the request */
        taskForPOSTMethod(UClient.Methods.UdacitySession, jsonBody: jsonBody!) { JSONResult, error in
            
            /* 3. Send the desired value to completion handler */
            /* check for errors and return info to user */
            if let error = error {
                print(error)
                
                /* catching the timeout error */
                if error.code == NSURLErrorTimedOut ||
                error.code == NSURLErrorNotConnectedToInternet {
                    completionHandler(success: false, sessionID: nil, userID: nil, errorString: "Cannot connect to Udacity server. Please check your connection.")
                } else {
                    completionHandler(success: false, sessionID: nil, userID: nil, errorString: "There was an error establishing a session with Udacity server. Please try again later.")
                }
                
                /* what if 403 ie invalid credentials? */
            } else if let error = JSONResult[UClient.JSONResponseKeys.ErrorMessage] as? String {
                print("\(error)")
                if JSONResult[UClient.JSONResponseKeys.Status] as? Int == 403 {
                    completionHandler(success: false, sessionID: nil, userID: nil, errorString: "Invalid username or password. Try again.")
                } else {
                    completionHandler(success: false, sessionID: nil, userID: nil, errorString: error)
                }
                
                /* do we have session? */
            } else if let sessionID = JSONResult.valueForKeyPath(UClient.JSONResponseKeys.SessionID) as? String {
                
                /* do we have user ID? */
                if let userID = JSONResult.valueForKeyPath(UClient.JSONResponseKeys.UserID) as? String {
                    
                    completionHandler(success: true, sessionID: sessionID, userID: userID, errorString: nil)
                }
            } else {
                print("Could not find \(UClient.JSONResponseKeys.SessionID) in \(JSONResult)")
                completionHandler(success: false, sessionID: nil, userID: nil, errorString: "There was an error establishing a session with Udacity server. Please try again later.")
            }
            
        }
    }
    
    /// logs out from Facebook and DELETEs Udacity session
    func logoutUdacityUser(completionHandler: (success: Bool, errorString: String?) -> Void) {
        let udacityMethod = UClient.Methods.UdacitySession
        
        logoutFromFacebook()
        
        taskForDELETEMethod(udacityMethod) { JSONResult, error in
            
            if let error = error {
                print(error)
                completionHandler(success: false, errorString: "There was an error while trying to logout from Udacity. Please try again later.")
            } else if let _ = JSONResult.valueForKeyPath(UClient.JSONResponseKeys.SessionID) as? String {
                
                // clear user information
                UdacityUser.clearData()
                
                completionHandler(success: true, errorString: nil)
            } else {
                print("Could not find \(UClient.JSONResponseKeys.SessionID) in \(JSONResult)")
                completionHandler(success: false, errorString: "There was an error while trying to logout from Udacity. Please try again later.")
            }
        }
        
    }
    
    //MARK: - Course Catalogue
    
    var courseCatalogueFilePath : String {
        let manager = NSFileManager.defaultManager()
        let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
        return url.URLByAppendingPathComponent("courseDictionary.plist").path!
    }
    
    
    /// Get the course catalogue and save it to Documents folder at courseCatalogueFilePath
    func updateUdacityCourseCatalogue(completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        // check if the course catalogue file exists
        if NSFileManager.defaultManager().fileExistsAtPath(courseCatalogueFilePath) {
            
            print("Found a course catalogue at: \(courseCatalogueFilePath)")
            
            // ... and check if its modification date is < 7 days
            do {
                let fileAttributes = try NSFileManager.defaultManager().attributesOfItemAtPath(courseCatalogueFilePath)
                let modificationDate = fileAttributes[NSFileModificationDate] as! NSDate
                let timeDifference = modificationDate.daysFrom(NSDate())
                
                print("Course Catalogue modified \(timeDifference) days ago")
                
                // no need to download the file if it's relatively new
                if timeDifference < 7 {
                    completionHandler(success: true, errorString: nil)
                    return
                }
                
            } catch {
                print("Error trying to access file attributes of the course catalogue file with path: \(courseCatalogueFilePath)")
                fatalError() // crash the app deliberately if we cannot read the file attributes
            }
        }
        
        // otherwise download the file
        taskForGETMethod(Methods.CourseCatalogue, concatenate: false) { (JSONResult, error) -> Void in
            print("Downloading the course catalogue")
            if let error = error {
                print("Error trying to download course catalogue: \(error)")
                completionHandler(success: false, errorString: "Couldn't download course catalogue")
            } else if let catalogue = JSONResult.valueForKey(JSONResponseKeys.Courses) as? NSArray {
                
                // Save the catalogue dictionary as a .plist
                catalogue.writeToFile(self.courseCatalogueFilePath, atomically: true)
                
                print("Course catalogue saved to: \(self.courseCatalogueFilePath)")
                
                completionHandler(success: true, errorString: nil)
            } else {
                print("Couldn't download course catalogue")
                completionHandler(success: false, errorString: "There was an error while trying to download course catalogue")
                
            }
        }
        
    }
    

}