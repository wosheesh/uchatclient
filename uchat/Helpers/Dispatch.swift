//
//  Dispatch.swift
//  uchat
//
//  Created by Wojtek Materka on 26/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Foundation

public typealias update_block = () -> Void

public func updateUI(block: update_block) {
    dispatch_async(dispatch_get_main_queue()) { 
        block()
    }

}