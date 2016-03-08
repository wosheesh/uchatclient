//
//  APIHelpers.swift
//  uchat
//
//  Created by Wojtek Materka on 04/03/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Foundation

extension RESTClient {

    /// Given raw JSON, return a usable Foundation object
    func parseJSONWithCompletionHandler(data: NSData, handler: CompletionHandlerType) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            handler(Result.Failure(APIError.JSONParseError))
        }

        handler(Result.Success(parsedResult))
    }

    /// Given a dictionary of parameters, convert to a string for a url
    func escapedParameters(parameters: [String : AnyObject]) -> String {
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

    /// Substitute the key for the value that is contained within the method name
    func subtituteKeyInMethod(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("{\(key)}") != nil {
            return method.stringByReplacingOccurrencesOfString("{\(key)}", withString: value)
        } else {
            return nil
        }
    }
    


    

}
