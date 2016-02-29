//
//  UConstants.swift
//  On the Map
//
//  Created by Wojtek Materka on 20/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

extension UClient {
    
    // MARK: - Constants
    struct Constants {
        
        // MARK: URLs
        static let BaseURL: String = "https://www.udacity.com/"
        
        // MARK: Timouts
        static let RequestTimeout : Double = 15
        static let ResourceTimeout : Double = 15
    }
    
    // MARK: - Methods
    struct Methods {
        
        // MARK: Authentication
        static let UdacitySession = "api/session"
        
        // MARK: User Data
        static let UdacityUserData = "api/users/{user_id}"
        
        // MARK: Course Catalogue
        static let CourseCatalogue = "public-api/v0/courses"
    }
    

    // MARK: - URL Keys
    struct URLKeys {
        
        static let UserId = "user_id"
        
    }
    
    // MARK: - Parameter Keys
    struct JSONBodyKeys {
        
        static let Username = "username"
        static let Password = "password"
        static let FBAccessToken = "access_token"
        
    }
    
    // MARK: - JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let Status = "status"
        static let ErrorMessage = "error"
        
        // MARK: Authorization
        static let UserID = "account.key"
        static let SessionID = "session.id"
        
        // MARK: Public User Data
        static let UserResults = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"
        static let UserKey = "key"
        
        // MARK: Enrolled courses
        static let Enrollments = "_enrollments"
        static let CourseKey = "node_key"
        
        // MARK: Course Catalogue
        static let Courses = "courses"
        static let CourseKeyCatalogue = "key"
        static let CourseTitle = "title"
        static let CourseSubtitle = "subtitle"
        static let CourseImage = "image"
        static let CourseBannerImage = "banner_image"
        
    }
}
