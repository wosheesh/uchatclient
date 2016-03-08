//
//  LoginViewUI.swift
//  On the Map
//
//  Created by Wojtek Materka on 31/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//


import UIKit

extension LoginViewController {
    
    // MARK: setupUI for LoginViewController
    
    func setupUI() {
        self.view.backgroundColor = UIColor.whiteColor()
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
