//
//  LoginViewController.swift
//  On the Map
//
//  Created by Wojtek Materka on 10/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

// TODO: add app Transport security for Udacity servers

import UIKit
import CoreData

class LoginViewController: UIViewController, ProgressViewPresenter {
    
    // MARK: - 🎛 Properties
    
    @IBOutlet weak var loginToUdacityLabel: UILabel!
    @IBOutlet weak var emailTextField: LoginTextField!
    @IBOutlet weak var passwordTextField: LoginTextField!
    @IBOutlet weak var loginButton: UdacityLoginButton!
    @IBOutlet weak var signupButton: UIButton!
    
    // ManagedObjectContextSettable
    var managedObjectContext: NSManagedObjectContext?
    
    // ProgressViewPresenter
    var messageFrame = UIView()

    // MARK: - 🔄 Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .Default
        
        // convenience for dev
        #if DEBUG
            emailTextField.text = envDict["UDACITY_EMAIL"]
            passwordTextField.text = envDict["UDACITY_PASS"]
        #endif
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // MARK: - 💥 Actions
    
    @IBAction func loginButtonTouch(sender: AnyObject) {
        self.setUIEnabled(enabled: false)
        showProgressView("Logging in")
        
        UClient.sharedInstance().authenticateWithUserCredentials(emailTextField.text!, password: passwordTextField.text!) { (success, errorString) in
            if success {
                self.managedObjectContext = createUchatMainContext()
                self.completeLogin()
            } else {
                self.displayError(errorString)
            }
        }
    }
    
    // open safari for udacity signup
    @IBAction func signUpButtonTouchUp(sender: AnyObject) {
        openSafariWithURLString("https://www.udacity.com/account/auth#!/signup")
    }

    //MARK: - 🐵 Helpers
    
    func displayError(errorString: String?) {
        dispatch_async(dispatch_get_main_queue(), {
            
            self.hideProgressView()
            self.setUIEnabled(enabled: true)
            if let errorString = errorString {
                
                simpleAlert(self, message: errorString)
            }
        })
    }
    
    func completeLogin() {
        updateUI {
            self.hideProgressView()
            self.setUIEnabled(enabled: false)
        }
        
        guard let nc = storyboard!.instantiateViewControllerWithIdentifier("ChatNav") as? UINavigationController,
            let vc = nc.viewControllers.first as? ManagedObjectContextSettable else {
                    fatalError("Wrong view controller type")
        }
        vc.managedObjectContext = managedObjectContext
        presentViewController(nc, animated: true, completion: nil)
    }
    
    // open with Safari helper
    func openSafariWithURLString(urlString: String) {
        let app = UIApplication.sharedApplication()
        
        if urlString.hasPrefix("http://") || urlString.hasPrefix("https://") {
            app.openURL(NSURL(string: urlString)!)
        } else {
            app.openURL(NSURL(fileURLWithPath: urlString, relativeToURL: NSURL(string: "http://")))
        }
    }
    
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == self.passwordTextField {
            loginButtonTouch(textField)
        }
        return true
    }
    
    // tapping outside of text field will dismiss keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
