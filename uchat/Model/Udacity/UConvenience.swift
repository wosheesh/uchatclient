//
//  UConvenience.swift
//  On the Map
//
//  Created by Wojtek Materka on 03/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit

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
            mutableMethod = self.subtituteKeyInMethod(mutableMethod, key: UClient.URLKeys.UserId, value: userID)!
           
            taskForHTTPMethod(mutableMethod, httpMethod: "GET", parameters: nil, jsonBody: nil) { result in
                switch result {
                case .Success(let JSONResult):
                    if let userData = JSONResult?[UClient.JSONResponseKeys.UserResults] as? [String : AnyObject] {
                        completionHandler(success: true, userData: userData, errorString: nil)
                    } else {
                        completionHandler(success: false, userData: nil, errorString: "Could not parse getUserDataWithUserID")
                    }
                case .Failure(let error):
                    
                    switch error {
                    case .ConnectionError:
                        completionHandler(success: false, userData: nil, errorString: APIError.ConnectionError.rawValue)
                    case .NoDataReceived:
                        completionHandler(success: false, userData: nil, errorString: APIError.NoDataReceived.rawValue)
                    case .JSONParseError:
                        completionHandler(success: false, userData: nil, errorString: APIError.JSONParseError.rawValue)
                    default:
                        completionHandler(success: false, userData: nil, errorString: APIError.Uncategorised.rawValue)
                    }

                    
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
                jsonBody = ["udacity": [UClient.JSONBodyKeys.Username: email as String!,
                    UClient.JSONBodyKeys.Password: password as String!]]
            }
        }
        
        /* 2. Make the request */
        
        taskForHTTPMethod(UClient.Methods.UdacitySession, httpMethod: "POST", parameters: nil, jsonBody: jsonBody) { result in
            
            switch result {
            case .Success(let JSONResult):
                
                // successful server response and we have sessionID + userID
                if let sessionID = JSONResult?.valueForKeyPath(UClient.JSONResponseKeys.SessionID) as? String,
                    let userID = JSONResult?.valueForKeyPath(UClient.JSONResponseKeys.UserID) as? String {
                        completionHandler(success: true, sessionID: sessionID, userID: userID, errorString: nil)
                }
                
                // successful server response but wrong email or password
                if let error = JSONResult?[UClient.JSONResponseKeys.ErrorMessage] as? String {
                    print("\(error)")
                    if JSONResult?[UClient.JSONResponseKeys.Status] as? Int == 403 {
                        completionHandler(success: false, sessionID: nil, userID: nil, errorString: "Invalid username or password. Try again.")
                    }
                }
                
            case .Failure(let error):
                
                switch error {
                case .ConnectionError:
                    print("Connection Error")
                    completionHandler(success: false, sessionID: nil, userID: nil, errorString: APIError.ConnectionError.rawValue)
                case .NoDataReceived:
                    print("No Data Received Error")
                    completionHandler(success: false, sessionID: nil, userID: nil, errorString: APIError.NoDataReceived.rawValue)
                case .JSONParseError:
                    print("JSONParse Error")
                    completionHandler(success: false, sessionID: nil, userID: nil, errorString: APIError.JSONParseError.rawValue)
                default:
                    print("default error")
                    completionHandler(success: false, sessionID: nil, userID: nil, errorString: APIError.Uncategorised.rawValue)
                }

            }
            
        }
    }
    
    
    /// logs out from Udacity session
    func logoutUdacityUser(handler: CompletionHandlerType) {
        let udacityMethod = UClient.Methods.UdacitySession
        
        taskForHTTPMethod(udacityMethod, httpMethod: "DELETE", parameters: nil, jsonBody: nil) { result in
            
            switch result {
            case .Success(let response):
                if let _ = response?.valueForKeyPath(UClient.JSONResponseKeys.SessionID) as? String {
                    handler(Result.Success(nil))
                }
            case .Failure(let error):
                print("🆘 ☎️ \(error)")
                handler(Result.Failure(error))
            }
            
        }
        
    }
    

    

}