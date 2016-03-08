//
//  DataSource.swift
//  uchat
//
//  Created by Wojtek Materka on 01/03/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import Foundation

protocol DataSourceDelegate: class {
    typealias Object
    func cellIdentifierForObject(object: Object) -> String
}