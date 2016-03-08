//
//  ParseConvenience.swift
//  On the Map
//
//  Created by Wojtek Materka on 03/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Foundation

extension ParseClient {
    
    /// Push notification using Parse server's REST API
    func push(jsonBody: [String : AnyObject], completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        let method: String = Methods.PushNotification
        let httpMethod: String = HttpMethods.PushNotification
        
        print("🚀 Parse push: \(jsonBody)")
        
        taskForHTTPMethod(method, httpMethod: httpMethod, parameters: nil, jsonBody: jsonBody) { result in
            
            switch result {
            case .Success(_):
                print("📮 message sent successfully")
            case .Failure(let error):
                switch error {
                case .ConnectionError:
                    completionHandler(success: false, errorString: ParseClient.Errors.TimeOut.rawValue)
                default:
                    completionHandler(success: false, errorString: ParseClient.Errors.PushCrash.rawValue)
                }
            }
        }
    }
    
}