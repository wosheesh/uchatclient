//
//  PictureCache.swift
//  uchat
//
//  Created by Wojtek Materka on 29/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit

class PictureCache {
    
    // MARK: - 📂 Retreiving pictures
    
    enum Errors: ErrorType {
        case NoFileFoundAtURL
    }
    
    func downloadPictureToDocuments(pictureUrl: NSURL, filename: String, completionHandler: (success: Bool, errorString: String?) -> Void) throws {
    
        
        let request = NSURLRequest(URL: pictureUrl)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let error = error {
                print("🆘 ☎️ Couldn't download picture for \(pictureUrl)")
                completionHandler(success: false, errorString: "Couldn't download picture")
            }
            
            if let data = data {
                // set the filename as the local identifier
                let image = UIImage(data: data)
                
                // save the file
                self.storePicture(image, withIdentifier: filename)
                
                print("🌈 Downloaded and saved at \(filename)")
                
                completionHandler(success: true, errorString: nil)
            }
        
        }
        
        task.resume()
        
    }

    
    
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
    
    // MARK: - 🖼 Saving Pictures
    
    /// Saves a picture on disk with a an identifier as file name.
    func storePicture(picture: UIImage?, withIdentifier identifier: String) {
        
        let path = pathForIdentifier(identifier)
        let data = UIImageJPEGRepresentation(picture!, 1.0)!
        data.writeToFile(path, atomically: true)
    }
    
    // MARK: - 🐵 Helpers
    
    /// Returns a file path as String given an identifier.
    func pathForIdentifier(identifier: String) -> String {
        let fullURL = NSURL.documentsURL.URLByAppendingPathComponent(identifier)
        return fullURL.path!
    }
}

