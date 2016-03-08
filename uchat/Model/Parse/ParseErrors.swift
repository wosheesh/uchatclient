//
//  ParseErrors.swift
//  uchat
//
//  Created by Wojtek Materka on 26/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Foundation

extension ParseClient {
    
    enum Errors: String {
        case TimeOut = "Request timed out - Check your connection"
        case PushCrash = "Something went wrong while trying to send your message. Try again later."
    }
    


}