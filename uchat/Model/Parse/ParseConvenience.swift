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
    func push(jsonBody: [String : AnyObject]) {
        
        let method: String = Methods.PushNotification
        let httpMethod: String = HttpMethods.PushNotification
        
        print("🚀 Parse push: \(jsonBody)")
        
        taskForHTTPMethod(method, httpMethod: httpMethod, parameters: nil, jsonBody: jsonBody) { result, error in
            if let error = error {
                print("error: \(error)")
            } else {
                print("result: \(result)")
            }
        }
        
    }
    
    

    
}