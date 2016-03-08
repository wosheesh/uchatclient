//
//  PictureCache.swift
//  uchat
//
//  Created by Wojtek Materka on 29/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit

class PictureCache: RESTClient {
    
    var session: NSURLSession = NSURLSession.sharedSession()
    
    // MARK: - 📥 Downloading pictures
    
    func downloadPicture(wwwPath: String, handler: CompletionHandlerType) {
        
        guard let url = NSURL(string: wwwPath) where url != "" else {
            print("🛡couldn't create an URL out of \(wwwPath)")
            handler(Result.Failure(APIError.URLError))
            return
        }
        
        downloadFile(url) { success, data, error in
            if success {
                guard let picture = UIImage(data: data!) else {
                    print("🛡couldn't save data as UIImage")
                    handler(Result.Failure(APIError.DataProcessingError))
                    return
                }
                
                print("created a picture from : \(url)")

                handler(Result.Success(picture))
            }
            
            if let error = error {
                self.processRESTErrorWithHandler(error, handler: handler)
            } else {
                handler(Result.Failure(APIError.Uncategorised))
            }
            
        }
        
    }
    
    // MARK: - 📂 Retreiving pictures
    
    /// Returns an UIImage given a String identifier.
    func pictureWithIdentifier(identifier: String?) -> UIImage? {
        if identifier == nil || identifier! == "" {
            return nil
        }
        
        let path = pathForIdentifier(identifier!)
        
        if let data = NSData(contentsOfFile: path) {
            return UIImage(data: data)
        }
        
        return nil
    }
    
    /// Returns a full file path as String given an identifier.
    func pathForIdentifier(identifier: String) -> String {
        let fullURL = NSURL.documentsURL.URLByAppendingPathComponent(identifier)
        return fullURL.path!
    }
    
    func defaultChannelPicture() -> UIImage {
        return UIImage(named: "defaultChannelPicture")!
    }
    
    // MARK: - 🖼 Saving Pictures
    
    /// Saves a picture on disk with a an identifier as file name.
    func storePicture(picture: UIImage?, withIdentifier identifier: String) {
        
        let path = pathForIdentifier(identifier)
        let data = UIImageJPEGRepresentation(picture!, 1.0)!
        data.writeToFile(path, atomically: true)
    }

}

