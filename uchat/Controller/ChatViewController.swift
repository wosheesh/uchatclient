//
//  ChatViewController.swift
//  uchat
//
//  Created by Wojtek Materka on 21/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

// TODO: Improve the chat bubbles UI
// TODO: Enter channel bubble

import UIKit

class ChatViewController: UIViewController {
    
    // MARK: - 🎛 Properties
    
    var channel: Channel!
    
    @IBOutlet weak var chatWall: UITableView!
    @IBOutlet weak var chatTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: - 🔄 Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
           
        // Keyboard notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardDidShow:"), name: UIKeyboardDidShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        // Set up UI controls
        self.chatWall.rowHeight = UITableViewAutomaticDimension
//        self.chatWall.estimatedRowHeight = 35.0
        self.chatWall.separatorStyle = .None
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // subscribe user to notifications from the current channel
        UdacityUser.setChannel(channel)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "displayNewMessage:", name: "newMessage", object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UdacityUser.setChannel(nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "newMessage", object: nil)
    }
    
    // MARK: - ⌨️ Keyboard scrolling
    
    func keyboardWillShow(notification: NSNotification) {
        let keyboardHeight = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey]?.CGRectValue.height
        UIView.animateWithDuration(0.1) { () -> Void in
            self.bottomConstraint.constant = keyboardHeight! + 10
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardDidShow(notification: NSNotification) {
        self.scrollToBottomMessage() // probably not needed
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.1) { () -> Void in
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - 🐵 Helpers
    
    
    func displayNewMessage(notification: NSNotification) {
        
        print("Local notification received")
        
        let userInfo = notification.object as! [NSObject : AnyObject]
        do {
            let newMessage = try Message.createFromPushNotification(userInfo)
            channel.messages.append(newMessage)
        } catch Message.MessageError.InvalidSyntax {
            print("Invalid syntax")
        } catch Message.MessageError.NoBodyFound {
            print("Body couldn't be found")
        } catch Message.MessageError.NoAuthorFound {
            print("Author couldnt be found")
        } catch Message.MessageError.NoChannelFound {
            print("Channel couldnt be found")
        } catch {
            print("Message error not handled")
        }
        
        chatWall.reloadData()
        
        
    }
    
    @IBAction func viewTapped(sender: AnyObject) {
        chatTextField.resignFirstResponder()
    }
    
    func scrollToBottomMessage() {
        if channel.messages.count == 0 {
            return
        }
        
        let bottomMessageIndex = NSIndexPath(forRow: chatWall.numberOfRowsInSection(0) - 1, inSection: 0)
        chatWall.scrollToRowAtIndexPath(bottomMessageIndex, atScrollPosition: .Bottom, animated: true)
    }
    
}
    // MARK: - 🔤 TextFieldDelegate

extension ChatViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
            
        if let msgBody = chatTextField.text where msgBody != "" {
            let message = Message(body: msgBody, creator: UdacityUser.currentUser)
            chatTextField.text = ""
            chatTextField.resignFirstResponder()
            
            
            message.Send(toChannel: self.channel)
        
            
            
            // TODO: remove the reload after push is implemented - channel.messages should update on network push not client write
            chatWall.reloadData()
        }
    return true
    }
}

    // MARK: - 📄 TableViewDelegate

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channel.messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("chatCell", forIndexPath: indexPath)
        let message = channel.messages[indexPath.row]
        
        cell.detailTextLabel?.text = message.author().username
        cell.textLabel?.text = message.text()
        cell.selectionStyle = .None
        return cell
    }
    
    
}

