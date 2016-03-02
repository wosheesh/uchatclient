//
//  SegueHandlerType.swift
//  uchat
//
//  Created by Wojtek Materka on 02/03/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit

public protocol SegueHandlerType {
    typealias SegueIdentifier: RawRepresentable
}

extension SegueHandlerType where Self: UIViewController, SegueIdentifier.RawValue == String {
    
    /// Helper function for easier segue handling. Returns the segue identifier for *UIStoryboardSegue* or fatal error if identifier not found
    /// - Returns: segueIdentifier
    public func segueIdentifierForSegue(segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier, let segueIdentifier = SegueIdentifier(rawValue: identifier) else { fatalError("Unknown segue: \(segue)") }
        return segueIdentifier
    }
    
    public func performSegue(segueIdentifier: SegueIdentifier) {
        performSegueWithIdentifier(segueIdentifier.rawValue, sender: nil)
    }
    
}
