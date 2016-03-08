//
//  UFacebook.swift
//  On the Map
//
//  Created by Wojtek Materka on 01/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit

let facebookReadPermissions = ["email"]

extension UClient {
    
    func authenticateWithFacebook(completionHandler: (success: Bool, error: NSError?) -> Void) {
        
        /* use FB Login Manager to authenticate */
        FBSDKLoginManager().logInWithReadPermissions(facebookReadPermissions, fromViewController: nil, handler: { result, error in
            
            if error != nil {
                
                FBSDKLoginManager().logOut()
                completionHandler(success: false, error: error)
            } else if result.isCancelled {
                
                // handle cancellations
                FBSDKLoginManager().logOut()
                let userInfo = [NSLocalizedDescriptionKey : "Facebook Login cancelled"]
                completionHandler(success: false, error: NSError(domain: "authenticateWithFacebook - cancel", code: 0, userInfo: userInfo))
            } else {
                let access_token = FBSDKAccessToken.currentAccessToken().tokenString
                
                /* if successful read user data from Udacity */
                self.getSessionID(nil, password: nil, access_token: access_token) { success, sessionID, userID, errorString in
                    
                    if success {
                        
                        self.getUserDataWithUserID(userID!) { success, userData, errorString in
                            
                            if success {
                                /* update User Information with Udacity data */
                                _ = UdacityUser(initCurrentUserFromData: userData!)
                                
                                completionHandler(success: success, error: nil)
                            } else {
                                let userInfo = [NSLocalizedDescriptionKey : errorString as String!]
                                completionHandler(success: success, error: NSError(domain: "authenticateWithFacebook - getUserDataWithUserID", code: 0, userInfo: userInfo)) // self.getUserDataWithUserID(userID!)
                            }
                        }
                        
                    } else {
                        let userInfo = [NSLocalizedDescriptionKey : errorString as String!]
                        completionHandler(success: success, error: NSError(domain: "authenticateWithFacebook - getSessionID",
                            code: 0, userInfo: userInfo)) // self.getSessionID
                    }
                    
                }
                
            }
        })
        
        
    }

    
//    // MARK: authenticateWithFacebook
//    func authenticateWithFacebook(completionHandler: (success: Bool, error: NSError?) -> Void) {
//        
//        /* use FB Login Manager to authenticate */
//        FBSDKLoginManager().logInWithReadPermissions(facebookReadPermissions, fromViewController: nil, handler: { result, error in
//            
//            if error != nil {
//                
//                FBSDKLoginManager().logOut()
//                completionHandler(success: false, error: error)
//            } else if result.isCancelled {
//                
//                // handle cancellations
//                FBSDKLoginManager().logOut()
//                let userInfo = [NSLocalizedDescriptionKey : "Facebook Login cancelled"]
//                completionHandler(success: false, error: NSError(domain: "authenticateWithFacebook - cancel", code: 0, userInfo: userInfo))
//            } else {
//                let access_token = FBSDKAccessToken.currentAccessToken().tokenString
//                
//                /* if successful read user data from Udacity */
//                self.getSessionID(nil, password: nil, access_token: access_token) { success, sessionID, userID, errorString in
//                    
//                    if success {
//                        
//                        self.getUserDataWithUserID(userID!) { success, userData, errorString in
//                            
//                            if success {
//                                /* update User Information with Udacity data */
//                                _ = UdacityUser(initCurrentUserFromData: userData!)
//                                
//                                completionHandler(success: success, error: nil)
//                            } else {
//                                let userInfo = [NSLocalizedDescriptionKey : errorString as String!]
//                                completionHandler(success: success, error: NSError(domain: "authenticateWithFacebook - getUserDataWithUserID", code: 0, userInfo: userInfo)) // self.getUserDataWithUserID(userID!)
//                            }
//                        }
//                        
//                    } else {
//                        let userInfo = [NSLocalizedDescriptionKey : errorString as String!]
//                        completionHandler(success: success, error: NSError(domain: "authenticateWithFacebook - getSessionID",
//                            code: 0, userInfo: userInfo)) // self.getSessionID
//                    }
//                    
//                }
//
//            }
//        })
//
//
//    }
    
    
    func logoutFromFacebook() {
        
        FBSDKLoginManager().logOut()
        
    }
    
}