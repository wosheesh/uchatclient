//
//  UCourseCatalogue.swift
//  uchat
//
//  Created by Wojtek Materka on 04/03/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Foundation

// MARK: - Course Catalogue

extension UClient {
    
var courseCatalogueFilePath : String {
    let url = NSURL.documentsURL
    return url.URLByAppendingPathComponent("courseDictionary.plist").path!
}


/// Get the course catalogue and save it to Documents folder at courseCatalogueFilePath
func updateUdacityCourseCatalogue(handler: CompletionHandlerType) {
    
    // check if the course catalogue file exists
    if NSFileManager.defaultManager().fileExistsAtPath(courseCatalogueFilePath) {
        
        print("Found a course catalogue at: \(courseCatalogueFilePath)")
        
        // ... and check if its modification date is < 7 days
        let fileAttributes = try! NSFileManager.defaultManager().attributesOfItemAtPath(courseCatalogueFilePath)
        let modificationDate = fileAttributes[NSFileModificationDate] as! NSDate
        let timeDifference = modificationDate.daysFrom(NSDate())
            
        print("Course Catalogue modified \(timeDifference) days ago")
            
        if timeDifference < 7 {
            handler(Result.Success(nil))
            return
        }
    }
    
    // otherwise download new catalogue and save file
    taskForHTTPMethod(Methods.CourseCatalogue, httpMethod: "GET", parameters: nil, jsonBody: nil, concatenate: false) { result in
        switch result {
        case .Success(let parsedResult):
            if let catalogue = parsedResult?.valueForKey(JSONResponseKeys.Courses) as? NSArray {
                catalogue.writeToFile(self.courseCatalogueFilePath, atomically: true)
                print("Course catalogue saved to: \(self.courseCatalogueFilePath)")
                handler(Result.Success(nil))
                return
            }
        case .Failure(let error):
            print("🆘 ☎️ \(error)")
            handler(Result.Failure(error))
            return
            
        }
    }

}


//    private func downloadCourseCatalogue(handler: CompletionHandlerType) {
//        
//
//        
////        taskForHTTPMethod(Methods.CourseCatalogue, concatenate: false) { (JSONResult, error) -> Void in
////            print("Downloading the course catalogue")
////            if let error = error {
////                processRESTErrorWithHandler(error, handler)
////            } else if let catalogue = JSONResult.valueForKey(JSONResponseKeys.Courses) as? NSArray {
////                // Save the catalogue dictionary as a .plist
////                catalogue.writeToFile(self.courseCatalogueFilePath, atomically: true)
////                print("Course catalogue saved to: \(self.courseCatalogueFilePath)")
////                handler(Result.Success(nil))
////            } else {
////                handler(Result.Failure(Error.Uncategorised))
////                
////            }
////        }
//    
//    }

}