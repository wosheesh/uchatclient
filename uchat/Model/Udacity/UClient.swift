//
//  UClient.swift
//  On the Map
//
//  Created by Wojtek Materka on 20/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Foundation

class UClient: NSObject {
    
    // MARK: Properties
    
    /* Shared session */
    var session: NSURLSession = NSURLSession.sharedSession()
    
    // MARK: Udacity API functions
    
    func taskForPOSTMethod(method: String, jsonBody: [String: AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Build the URL */
        let urlString = Constants.BaseURL + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        /* 2. Configure the request */
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }
        
        /* 3. Make the request */
        
        // Set the session interval timeout
        let urlconfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        urlconfig.timeoutIntervalForRequest = Constants.RequestTimeout
        urlconfig.timeoutIntervalForResource = Constants.ResourceTimeout
        self.session = NSURLSession(configuration: urlconfig, delegate: nil, delegateQueue: nil)
        
        // request
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: was there an error? */
            guard (error == nil) else {
                print("There was an error: \(error) while calling method: \(method)")
                completionHandler(result: nil, error: error)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("\(__FUNCTION__) in \(__FILE__) returned no data")
                completionHandler(result: nil, error: error)
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            /* 4. Parse the data and use the data in completion handler */
            UClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
        }
        
        /* 5. Start the request */
        task.resume()

        return task
    }
    
    func taskForGETMethod(method: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Build the URL */
        let urlString = Constants.BaseURL + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        /* 2. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: was there an error? */
            guard (error == nil) else {
                print("There was an error: \(error) while calling method: \(method)")
                if error?.code == NSURLErrorTimedOut {
                    completionHandler(result: nil, error: error)
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("\(__FUNCTION__) in \(__FILE__) returned no data")
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            /* 3. Parse the data and use the data in completion handler */
            UClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
        }
        
        /* 4. Start the request */
        task.resume()
        
        return task
        
    }
    
    func taskForDELETEMethod(method: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Build the URL */
        let urlString = Constants.BaseURL + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        /* 2. Configure the request with cookie info */
        request.HTTPMethod = "DELETE"
        
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        /* 3. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: was there an error? */
            guard (error == nil) else {
                print("There was an error: \(error) while calling method: \(method)")
                if error?.code == NSURLErrorTimedOut {
                    completionHandler(result: nil, error: error)
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("\(__FUNCTION__) in \(__FILE__) returned no data")
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            
            /* 4. Parse the data and use the data in completion handler */
            UClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
        }
        
        /* 5. Start the request */
        task.resume()
        
        return task
        
    }


    // MARK: Shared Instance
    
    class func sharedInstance() -> UClient {
        struct Singleton {
            static var sharedInstance = UClient()
        }
        
        return Singleton.sharedInstance
    }
    
    // MARK: Helpers
    
    /// Given raw JSON, return a usable Foundation object
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
    
    /// Substitute the key for the value that is contained within the method name
    class func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
}

    
