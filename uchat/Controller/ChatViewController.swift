//
//  ChatViewController.swift
//  uchat
//
//  Created by Wojtek Materka on 21/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit
import CoreData

class ChatViewController: UIViewController, ManagedObjectContextSettable {
    
    // MARK: - 🎛 Properties
    
    var managedObjectContext: NSManagedObjectContext!
    var channel: Channel!
    
    @IBOutlet weak var chatWall: UITableView!
    @IBOutlet weak var chatTextView: ChatTextView!
    @IBOutlet weak var inputBar: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatTextViewHeightConst: NSLayoutConstraint!
    static let chatTextViewMinHeight = 30.0
    
    // MARK: - 🔄 Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        
        // Set up UI
        navigationItem.title = channel.name
        navigationController?.navigationBar.tintColor = OTMColors.UBlue
        chatWall.rowHeight = UITableViewAutomaticDimension
        chatWall.separatorStyle = .None
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeChannel()
        becomeKeyboardWizard()
        
        // subscribe to notifications about application state (to make sure we unsubscribe from current channel if user hits the home key or quits the app)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"unsubscribeChannel" , name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"unsubscribeChannel" , name: UIApplicationWillTerminateNotification, object: nil)
        
        // ... and if application enters foreground again
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "subscribeChannel", name: UIApplicationWillEnterForegroundNotification, object: nil)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillTerminateNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillEnterForegroundNotification, object:  nil)
        
        deregisterKeyboardWizard()
        unsubscribeChannel()
    }
    
    // MARK: - 📬 Receive and display messages
    
    func processNewMessage(notification: NSNotification) {
        
        let userInfo = notification.object as! [NSObject : AnyObject]
        do {
            // create a newMessage object when push is received
            try Message.createFromPushNotification(userInfo, inContext: managedObjectContext, currentChannel: channel)
            
        } catch let error as APIError {
            print(error.rawValue)
        } catch {
            print("🆘 📫 error receiving new message")
        }
        

    }
    
    // MARK: - 📮 Send a message to current channel
    
    @IBAction func sendButtonTouchUp(sender: AnyObject) {
        
        // Save the message in current context and send it
        if let body = chatTextView.text where body != "" {
            managedObjectContext.performChanges {
                Message.insertIntoContextAndSend(self.managedObjectContext, body: body, channel: self.channel, sender: self)
            }
            
            // clean up the textView
            chatTextView.text = ""
            chatTextView.resignFirstResponder()
            chatTextViewHeightConst.constant = chatTextView.minChatTextViewHeight()
        }
    }
    
    // MARK: - 🐵 Helpers
    
    func subscribeChannel() {
        channel.subscribeUser(inView: self)
    }
    
    func unsubscribeChannel() {
        channel.unsubscribeUser(fromView: self)
    }

    @IBAction func viewTapped(sender: AnyObject) {
        chatTextView.resignFirstResponder()
    }
    
    
    // MARK: - Private
    
    private typealias Data = FetchedResultsDataProvider<ChatViewController>
    private var dataSource: TableViewDataSource<ChatViewController, Data, ChatTableCell>!
    
    private func setupDataSource() {
        let request = Message.sortedFetchRequest
        
        let channelPredicate = NSPredicate(format: "channel == %@", channel)
        let receivedPredicate = NSPredicate(format: "receivedAt != nil")
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [channelPredicate, receivedPredicate])
        request.predicate = compoundPredicate
        request.returnsObjectsAsFaults = false
        
        print("running fetch request on Message")
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        print("configuring dataProvider for ChatTable")
        let dataProvider = FetchedResultsDataProvider(fetchedResultsController: frc, delegate: self)
        print("configuring dataSource for ChatTable")
        dataSource = TableViewDataSource(tableView: chatWall, dataProvider: dataProvider, delegate: self)
    }
    

    
}


// MARK: - 🎩 DataProviderDelegate & DataSourceDelegate

extension ChatViewController: DataProviderDelegate {
    func dataProviderDidUpdate(updates: [DataProviderUpdate<Message>]?) {
        dataSource.processUpdates(updates)
        dataSource.scrollToLastRow()
    }
}

extension ChatViewController: DataSourceDelegate {
    func cellIdentifierForObject(object: Message) -> String {
        return "ChatCell"
    }
}


// MARK: - 🔤 TextViewDelegate

extension ChatViewController: UITextViewDelegate {
    
    func textViewDidChange(textView: UITextView) {
        chatTextViewHeightConst.constant = chatTextView.appropriateHeight()
    }
    
}

// MARK: - 📄 TableViewDelegate

extension ChatViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

// MARK: - ⌨️ Keyboard scrolling

extension ChatViewController {

    func becomeKeyboardWizard() {
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: nil) { notification in
            self.keyboardWillShow(notification)
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillHideNotification, object: nil, queue: nil) { notification in
            self.keyboardWillHide(notification)
        }
    }
    
    func deregisterKeyboardWizard() {
        NSNotificationCenter.defaultCenter().removeObserver(UIKeyboardWillShowNotification)
        NSNotificationCenter.defaultCenter().removeObserver(UIKeyboardWillHideNotification)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let keyboardHeight = notification.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue.height
        
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
       
        updateUI {
            UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions(rawValue: curve), animations: {
                self.bottomConstraint.constant = keyboardHeight!
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        
        updateUI {
            UIView.animateWithDuration(duration, delay: 0, options: UIViewAnimationOptions(rawValue: curve), animations: {
                self.bottomConstraint.constant = 0
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
}