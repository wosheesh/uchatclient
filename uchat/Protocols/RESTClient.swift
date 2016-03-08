//
//  RESTClient.swift
//  uchat
//
//  Created by Wojtek Materka on 04/03/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Foundation

protocol RESTClient: class {
    var session: NSURLSession { get set }
}

