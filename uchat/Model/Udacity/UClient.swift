//
//  UClient.swift
//  On the Map
//
//  Created by Wojtek Materka on 20/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Foundation


class UClient: RESTClient {
    
    // MARK: Properties

    var session: NSURLSession = NSURLSession.sharedSession()
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UClient {
        struct Singleton {
            static var sharedInstance = UClient()
        }
        
        return Singleton.sharedInstance
    }
    
    // MARK: Udacity API functions
    
    func taskForHTTPMethod(method: String, httpMethod: String, parameters: [String : AnyObject]?, jsonBody: [String : AnyObject]?, concatenate: Bool = true, handler: CompletionHandlerType) -> NSURLSessionDataTask {
        
        // 1. Build the URL
        let urlString = Constants.BaseURL + method
        let url = NSURL(string: urlString)!
        var request = NSMutableURLRequest(URL: url)
        
        // 2. Configure the headers
        switch httpMethod {
        case "GET":
            break
        case "POST":
            request = configRequestForPOST(request, jsonBody: jsonBody!)
        case "DELETE":
            request = configRequestForDELETE(request)
        default:
            fatalError("Wrong HTTP Method called in Udacity REST")
        }
        
        // 3. Set the session timeout interval
        let urlconfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        urlconfig.timeoutIntervalForRequest = Constants.RequestTimeout
        urlconfig.timeoutIntervalForResource = Constants.ResourceTimeout
        self.session = NSURLSession(configuration: urlconfig, delegate: nil, delegateQueue: nil)
        
        // 5. Run the request
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: was there an error? */
            guard (error == nil) else {
                self.processRESTErrorWithHandler(error!, handler: handler)
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard var data = data else {
                handler(Result.Failure(APIError.NoDataReceived))
                return
            }
            
            // adjust for Udacity's 5 character shift
            if concatenate { data = data.subdataWithRange(NSMakeRange(5, data.length - 5)) }

            
            // 6. Parse the data and use the data in completion handler
            self.parseJSONWithCompletionHandler(data, handler: handler)
        }
        
        // 7. Start the request
        task.resume()
        return task
    }
    
    func configRequestForPOST(request: NSMutableURLRequest, jsonBody: [String : AnyObject]) -> NSMutableURLRequest {
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }
        return request
    }
    
    func configRequestForDELETE(request: NSMutableURLRequest) -> NSMutableURLRequest {
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        return request
    }
    
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
            UClient.parseJSONWithCompletionHandler1(newData, completionHandler: completionHandler)
        }
        
        /* 5. Start the request */
        task.resume()
        
        return task
    }

    class func parseJSONWithCompletionHandler1(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandler(result: parsedResult, error: nil)
    }

    
   
}

    
