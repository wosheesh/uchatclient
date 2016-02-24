//
//  ParseClient.swift
//  On the Map
//
//  Created by Wojtek Materka on 21/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Foundation

class ParseClient {
    
    // MARK: Properties
    
    // Singleton
    static let sharedInstance = ParseClient()
    private init() {}

    /* Shared session */
    var session: NSURLSession = NSURLSession.sharedSession()
    
    // MARK: taskForHTTPMethod

    /// This if a flexible method for running Parse API HTTP requests
    func taskForHTTPMethod(method: String, httpMethod: String, parameters: [String : AnyObject]?, jsonBody: [String:AnyObject]?, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Build the URL */
        var urlString = String()
        
        if let mutableParameters = parameters {
            urlString = Constants.BaseURLSecure + method + ParseClient.escapedParameters(mutableParameters)
        } else {
            urlString = Constants.BaseURLSecure + method
        }
        
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        /* 2. Build the HTTP Headers */
        // Values for the AppID and APIKey
        request.addValue(Constants.ParseAppID, forHTTPHeaderField: Constants.ParseAppIDHTTPHeader)
        request.addValue(Constants.ParseMasterKey, forHTTPHeaderField: Constants.ParseMasterKeyHTTPHeader)
        
        //Parse doesn't need "GET" to be specified in HttpBody
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
                print("[Parse \(httpMethod) Method: \(method)] There was an error: \(error)")
                completionHandler(result: nil, error: error)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("[Parse \(httpMethod) Method: \(method)] No data returned by request")
                completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: [NSLocalizedDescriptionKey : "Could not receive any data"]))
                return
            }
            
            /* 4. Parse the data and use the data (happens in completion handler) */
            ParseClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }
        
        /* 5. Start the request */
        task.resume()
        
        return task
        
    }
    
    // MARK: Helpers
    
    /* Helper: Given raw JSON, return a usable Foundation object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandler(result: parsedResult, error: nil)
    }
    
    /* Helper: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLUserAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    /* Helper: Substitute the key for the value that is contained within the method name */
    class func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    
}