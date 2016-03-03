//
//  KeyboardWizard.swift
//  uchat
//
//  Created by Wojtek Materka on 02/03/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit

// Moves the view to accommodate appearing keyboard. Uses autolayout constraint.

protocol KeyboardWizard: class {
    weak var bottomConstraint: NSLayoutConstraint! { get }
}

extension KeyboardWizard where Self: UIViewController {
    func becomeKeyboardWizard() {
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: nil) { [unowned self] notification in
            self.keyboardWillShow(notification)
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillHideNotification, object: nil, queue: nil) { [unowned self] notification in
            self.keyboardWillHide(notification)
        }
    }
    
    func deregisteKeyboardWizard() {
        NSNotificationCenter.defaultCenter().removeObserver(UIKeyboardWillShowNotification)
        NSNotificationCenter.defaultCenter().removeObserver(UIKeyboardWillHideNotification)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let keyboardHeight = notification.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue.height
        UIView.animateWithDuration(0.1) { () -> Void in
            self.bottomConstraint.constant = keyboardHeight! + 10
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.1) { () -> Void in
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}


// Cannot inject code into UIViewController lifecycle with protocol so using subclassing
//
//class KeyboardWizard: KeyboardWizardDelegate {
//    
////    var delegate : KeyboardWizardDelegate!
//    
//    // MARK: - Notifications
//    
//    override func viewDidLoad() {
//        print("Signing up for keyboard wizard notifs")
//        NSNotificationCenter.defaultCenter().addObserver(self,
//            selector: Selector("keyboardWillShow:"),
//            name: UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self,
//            selector: Selector("keyboardDidShow:"),
//            name: UIKeyboardDidShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self,
//            selector: Selector("keyboardWillHide:"),
//            name: UIKeyboardWillHideNotification, object: nil)
//    }
//    
//    override func viewDidDisappear(animated: Bool) {
//        print("Removing keyboard wizard notifs")
//        NSNotificationCenter.defaultCenter().removeObserver(UIKeyboardDidShowNotification)
//        NSNotificationCenter.defaultCenter().removeObserver(UIKeyboardWillShowNotification)
//        NSNotificationCenter.defaultCenter().removeObserver(UIKeyboardWillHideNotification)
//    }
//    
//    // MARK: - ⌨️ Keyboard scrolling
//    func keyboardWillShow(notification: NSNotification) {
//        let keyboardHeight = notification.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue.height
//        UIView.animateWithDuration(0.1) { () -> Void in
//            self.delegate.bottomConstraint.constant = keyboardHeight! + 10
//            self.view.layoutIfNeeded()
//        }
//    }
//    
//    func keyboardDidShow(notification: NSNotification) {
//    }
//    
//    func keyboardWillHide(notification: NSNotification) {
//        UIView.animateWithDuration(0.1) { () -> Void in
//            self.delegate.bottomConstraint.constant = 0
//            self.view.layoutIfNeeded()
//        }
//    }
//
//
//}
