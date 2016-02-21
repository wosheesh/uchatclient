//
//  Alerts.swift
//  uchat
//
//  Created by Wojtek Materka on 21/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit

class Alerts {
    
    func simpleAlert(target: UIViewController, message: String, title: String = "uChat") {
        print("Simple Alert called by \(target)")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { action in
            print("OK pressed on Alert Controller")
        }
        
        alertController.addAction(OKAction)
        
        target.presentViewController(alertController, animated: true, completion: nil)
    }
}
