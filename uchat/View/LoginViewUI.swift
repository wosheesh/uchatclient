//
//  LoginViewUI.swift
//  On the Map
//
//  Created by Wojtek Materka on 31/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//


import UIKit

@IBDesignable
extension LoginViewController {
    
    // MARK: setupUI for LoginViewController
    
    func setupUI() {
        
        /* Configure background gradient */
        self.view.backgroundColor = UIColor.whiteColor()
//        let colorTop = OTMColors.bgLight.CGColor
//        let colorBottom = OTMColors.bgDark.CGColor
//        let backgroundGradient = CAGradientLayer()
//        backgroundGradient.colors = [colorTop, colorBottom]
//        backgroundGradient.locations = [0.0, 1.0]
//        backgroundGradient.frame = view.frame
//        self.view.layer.insertSublayer(backgroundGradient, atIndex: 0)
        
    }
    
    // MARK: setUIenabled
    
        func setUIEnabled(enabled enabled: Bool) {
            emailTextField.enabled = enabled
            passwordTextField.enabled = enabled
            loginButton.enabled = enabled
    
            if enabled {
                loginButton.alpha = 1.0
            } else {
                loginButton.alpha = 0.5
            }
        }
    
}
