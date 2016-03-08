//
//  UdacityUser.swift
//  On the Map
//
//  Created by Wojtek Materka on 29/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Parse

struct UdacityUser {
    
    // MARK: - Properties
    
    // I am using mutable variables to allow different logins and clearData().
    // Surely there must be a better way, but didn't find it yet.
    static var udacityKey : String?
    static var username: String?
    static var enrolledCourses: [String]?

    // MARK: - Init
    
    init(initCurrentUserFromData userData: [String:AnyObject]) {
        UdacityUser.udacityKey = userData[UClient.JSONResponseKeys.UserKey] as? String
        
        // Using First Name as the username to display in chat.
        // I wasn't sure about the reliabiltity of "nickname" field.
        UdacityUser.username = userData[UClient.JSONResponseKeys.FirstName] as? String
        
        // Getting all the courses the user is enrolled in
        guard let courseList = userData[UClient.JSONResponseKeys.Enrollments] as? [[String : AnyObject]]
            where courseList.count > 0 else {
            print("Couldn't find any courses for the user")
            return
        }
        
        UdacityUser.enrolledCourses = courseList.map { (course) -> String in
            return course[UClient.JSONResponseKeys.CourseKey] as! String
        }
        
    }
    
    static func logout(handler: CompletionHandlerType) {
        UClient.sharedInstance().logoutUdacityUser { result in
            switch result {
            case .Success(_):
                UdacityUser.username = nil
                UdacityUser.udacityKey = nil
                UdacityUser.enrolledCourses = nil
                handler(Result.Success(nil))
            case .Failure(let error):
                handler(Result.Failure(error))
            }
        }
    }

}
    


