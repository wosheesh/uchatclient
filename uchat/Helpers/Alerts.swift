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
    var progressView: UIView {get set}
}

extension ProgressViewPresenter where Self: UIViewController {
    
/* shows an activity indicator with a simple message */
    func showProgressView(message: String) {
        
        guard let topView = UIApplication.topViewController(self) else {
            fatalError("WHere is my top controller?")
        }
        
        // get a blurred screenshot
        let blurView = blurUIView(topView)
        
        //Create an activity indicator inside messageFrame
        var activityIndicator = UIActivityIndicatorView()
        var strLabel = UILabel()
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = message
        strLabel.textColor = UIColor.whiteColor()
        let messageFrame = UIView(frame: CGRect(x: topView.view.frame.midX - 90, y: topView.view.frame.midY - 25 , width: 180, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.startAnimating()
        messageFrame.addSubview(activityIndicator)
        messageFrame.addSubview(strLabel)
        
        // Wrap it all in one view
        updateUI {
            self.navigationController?.navigationBar.layer.zPosition = -1
            self.progressView = UIView(frame: self.view.bounds)
            self.progressView.addSubview(blurView)
            self.progressView.addSubview(messageFrame)
        
            self.view.addSubview(self.progressView)
        }
        
    }
    
    func hideProgressView() {
        updateUI {
            self.navigationController?.navigationBar.layer.zPosition = 0
            self.progressView.removeFromSuperview()
        }
    }
    
    func blurUIView(target: UIViewController) -> UIView {
        
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, true, 1)
        self.view.drawViewHierarchyInRect(self.view.bounds, afterScreenUpdates: true)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Take a screenshot
        //        let screenshot = window.capture()
        
        //Add an UIImageView and blur it
        let blurView = UIImageView(image: screenshot)
        blurView.makeBlurImage(withStyle: .Light)
        
        return blurView
    }
    
    func blurUIWindow() -> UIView {
        
        let window: UIWindow! = UIApplication.sharedApplication().keyWindow
        
        UIGraphicsBeginImageContextWithOptions(window.frame.size, window.opaque, UIScreen.mainScreen().scale)
        window.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Take a screenshot
//        let screenshot = window.capture()
        
        //Add an UIImageView and blur it
        let blurView = UIImageView(image: screenshot)
        blurView.makeBlurImage(withStyle: .Light)
    
        return blurView
    }

}

extension UIApplication {
    
    class func topViewController(base: UIViewController? = (UIApplication.sharedApplication().delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
    
}

