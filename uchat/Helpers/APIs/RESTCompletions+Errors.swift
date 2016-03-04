//
//  RESTCompletions+Errors.swift
//  uchat
//
//  Created by Wojtek Materka on 04/03/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Foundation

typealias CompletionHandlerType = (Result) -> Void

enum Result {
    case Success(AnyObject?)
    case Failure(APIError)
}

extension String: ErrorType { }

enum APIError: String {
    case ConnectionError = "Cannot connect to the server. Please check your connection"
    case NoDataReceived = "Didn't receive any data from the server"
    case JSONParseError = "Couldn't process the data received from the server"
    case Uncategorised = "There was a strange error while trying to fetch data"
    
}



extension NSError {
    public func isAboutConnection() -> Bool {
        return self.code == NSURLErrorTimedOut || self.code == NSURLErrorNotConnectedToInternet
    }
    
}

extension RESTClient {
    
    func processRESTErrorWithHandler(error: NSError, handler: CompletionHandlerType) {
        if error.isAboutConnection() {
            handler(Result.Failure(APIError.ConnectionError))
        } else {
            handler(Result.Failure(APIError.Uncategorised))
        }
    }
    
}