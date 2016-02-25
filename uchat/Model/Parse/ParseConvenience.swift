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
    func push(message: Message, channel: Channel) {
        
        let method: String = Methods.PushNotification
        let httpMethod: String = HttpMethods.PushNotification
        
        let jsonBody: [String: AnyObject] = [
            "channels" : [channel.name],
            "data": [
                "alert": message.text(),
                ParseClient.PushKeys.MessageAuthor: message.author().username!,
                ParseClient.PushKeys.CurrentChannel: channel.name
            ] as [String: String]
        
        ]
        
        print("🚀 Parse push: \(jsonBody)")
        
        taskForHTTPMethod(method, httpMethod: httpMethod, parameters: nil, jsonBody: jsonBody) { (result, error) -> Void in
            if let error = error {
                print("error: \(error)")
            } else {
                print("result: \(result)")
            }
        }
        
    }
    
    

    
}