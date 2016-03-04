//
//  ParseClient.swift
//  On the Map
//
//  Created by Wojtek Materka on 21/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Foundation

class ParseClient: RESTClient {
    
    // MARK: Properties
    
    // Singleton
    static let sharedInstance = ParseClient()
    private init() {}

    /* Shared session */
    var session: NSURLSession = NSURLSession.sharedSession()
    
    // MARK: taskForHTTPMethod

    /// This if a flexible method for running Parse API HTTP requests
    func taskForHTTPMethod(method: String, httpMethod: String, parameters: [String : AnyObject]?, jsonBody: [String:AnyObject]?, handler: CompletionHandlerType) -> NSURLSessionDataTask {
        
        /* 1. Build the URL */
        var urlString = String()
        
        if let mutableParameters = parameters {
            urlString = Constants.BaseURLSecure + method + escapedParameters(mutableParameters)
        } else {
            urlString = Constants.BaseURLSecure + method
        }
        
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        /* 2. Build the HTTP Headers */
        // Values for the AppID and APIKey
        request.addValue(Constants.ParseAppID, forHTTPHeaderField: Constants.ParseAppIDHTTPHeader)
        request.addValue(Constants.ParseMasterKey, forHTTPHeaderField: Constants.ParseMasterKeyHTTPHeader)
        
        //TODO: Check if Parse doesn't need "GET" to be specified in HttpBody
        if httpMethod != "GET" { request.HTTPMethod = httpMethod }
        
        if let jsonBody = jsonBody {
            do {
                request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
            }
        }

        /* 3. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, result, error) in
        
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                self.processRESTErrorWithHandler(error!, handler: handler)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                handler(Result.Failure(APIError.NoDataReceived))
                return
            }
            
            /* 4. Parse the data and use the data (happens in completion handler) */
            self.parseJSONWithCompletionHandler(data, handler: handler)
        }
        
        /* 5. Start the request */
        task.resume()
        
        return task
        
    }
    

    
}