//
//  Utilities.swift
//  uchat
//
//  Created by Wojtek Materka on 01/03/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Foundation
import UIKit

func downloadFile(url: NSURL, handler: (success: Bool, data: NSData?, error: NSError?) -> Void) -> NSURLSessionDataTask{
    let session = NSURLSession.sharedSession()
    let request = NSMutableURLRequest(URL: url)
    print("\(__FUNCTION__) trying to download: \(url)")
    request.HTTPMethod = "GET"
    let task = session.dataTaskWithRequest(request) { data, response, error in
        
        guard (error == nil) else {
            print("Couldn't find the file [\(url)], with error: [\(error)]")
            handler(success: false, data: nil, error: error)
            return
        }
        
        guard let data = data else {
            print("Couldn't extract data from file: \(error)")
            handler(success: false, data: nil, error: nil)
            return
        }
        
        handler(success: true, data: data, error: nil)
    }
    
    task.resume()
    return task
}



extension NSURL {
    
    static func temporaryURL() -> NSURL {
        return try! NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true).URLByAppendingPathComponent(NSUUID().UUIDString)
    }
    
    static var documentsURL: NSURL {
        return try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
    }
    
}

extension UIWindow {
    
    func capture() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, self.opaque, UIScreen.mainScreen().scale)
        self.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
}
