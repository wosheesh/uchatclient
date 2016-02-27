//
//  LoginViewController.swift
//  On the Map
//
//  Created by Wojtek Materka on 10/01/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

// TODO: add app Transport security for Udacity servers

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - 🎛 Properties
    
    @IBOutlet weak var loginToUdacityLabel: UILabel!
    @IBOutlet weak var emailTextField: LoginTextField!
    @IBOutlet weak var passwordTextField: LoginTextField!
    @IBOutlet weak var loginButton: UdacityLoginButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginWithFBButton: FBLoginButton!
    
    /* for progress view */
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    /* shared session */
    var session: NSURLSession!
    
    // MARK: - 🔄 Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Get the shared URL session */
        session = NSURLSession.sharedSession()
        
        // Debugging
        
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
                self.completeLogin()
            } else {
                self.displayError(errorString)
            }
        }
    }
    
    @IBAction func loginWithFBButtonTouchUp(sender: AnyObject) {
        self.setUIEnabled(enabled: false)
        showProgressView("Logging in")
        
        UClient.sharedInstance().authenticateWithFacebook { (success, error) in
            if success {
                self.completeLogin()
            } else {
                if error?.domain == "authenticateWithFacebook - getSessionID" {
                    self.displayError("Couldn't link your Facebook account with Udacity profile. Check in https://www.udacity.com/account#!/linked-accounts")
                } else if error?.domain == "authenticateWithFacebook - cancel" {
                    self.displayError("Facebook authentication cancelled.")
                } else {
                    self.displayError("Something went wrong with Facebook authentication. Try again later.")
                }
            }
        }
    }
    
    /* open safari for udacity signup */
    @IBAction func signUpButtonTouchUp(sender: AnyObject) {
        openSafariWithURLString("https://www.udacity.com/account/auth#!/signup")
    }
    
    // MARK: - 💁 Convenience
    
    /* shows an activity indicator with a simple message */
    func showProgressView(message: String) {
        
        // TODO: turn this into a class or UIView extension for re-use
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 200, height: 50))
        strLabel.text = message
        strLabel.textColor = UIColor.whiteColor()
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25 , width: 180, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.startAnimating()
        messageFrame.addSubview(activityIndicator)
        
        messageFrame.addSubview(strLabel)
        view.addSubview(messageFrame)
        
    }
    
    //MARK: - 🐵 Helpers
    
    func displayError(errorString: String?) {
        dispatch_async(dispatch_get_main_queue(), {
            
            self.messageFrame.removeFromSuperview()
            self.setUIEnabled(enabled: true)
            if let errorString = errorString {
                
                simpleAlert(self, message: errorString)
            }
        })
    }
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            
            self.messageFrame.removeFromSuperview()
            self.setUIEnabled(enabled: false)
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("ChatNav") as! UINavigationController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
    /* open with Safari helper */
    func openSafariWithURLString(urlString: String) {
        let app = UIApplication.sharedApplication()
        
        if urlString.hasPrefix("http://") || urlString.hasPrefix("https://") {
            app.openURL(NSURL(string: urlString)!)
        } else {
            app.openURL(NSURL(fileURLWithPath: urlString, relativeToURL: NSURL(string: "http://")))
        }
    }
 
}

// MARK: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == self.passwordTextField {
            loginButtonTouch(textField)
        }
        return true
    }
    
    /* tapping outside of text field will dismiss keyboard */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
