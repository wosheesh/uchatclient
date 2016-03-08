//
//  ConfigurableCell.swift
//  uchat
//
//  Created by Wojtek Materka on 01/03/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

protocol ConfigurableCell {
    typealias DataSource
    func configureForObject(object: DataSource)
}
