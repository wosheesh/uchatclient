//
//  Alerts.swift
//  uchat
//
//  Created by Wojtek Materka on 21/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit

public func simpleAlert(target: UIViewController, message: String, title: String = "uChat") {
    print("Simple Alert called by \(target)")
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    
    let OKAction = UIAlertAction(title: "OK", style: .Default) { action in
        print("OK pressed on Alert Controller")
    }
    
    alertController.addAction(OKAction)
    
    updateUI { _ in
        target.presentViewController(alertController, animated: true, completion: nil)
    }
    
}

protocol ProgressViewPresenter: class {
    var messageFrame: UIView {get set}
}

extension ProgressViewPresenter where Self: UIViewController {
    
/* shows an activity indicator with a simple message */
    func showProgressView(message: String) {
        
        // for progress view
        
        var activityIndicator = UIActivityIndicatorView()
        var strLabel = UILabel()
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = message
        strLabel.textColor = UIColor.whiteColor()
        messageFrame = UIView(frame: CGRect(x: self.view.frame.midX - 90, y: self.view.frame.midY - 25 , width: 180, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.startAnimating()
        messageFrame.addSubview(activityIndicator)
        
        messageFrame.addSubview(strLabel)
        updateUI { self.view.addSubview(self.messageFrame) }
        
    }
    
    func hideProgressView() {
        updateUI { self.messageFrame.removeFromSuperview() }
    }

}

