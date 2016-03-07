//
//  ChatViewController.swift
//  uchat
//
//  Created by Wojtek Materka on 21/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

// TODO: Improve the chat bubbles UI sizes

import UIKit
import CoreData

class ChatViewController: UIViewController, KeyboardWizard, ManagedObjectContextSettable {
    
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
        becomeKeyboardWizard()
        setupDataSource()
        
        // Set up UI
        navigationController?.navigationBar.tintColor = OTMColors.UBlue
        self.chatWall.rowHeight = UITableViewAutomaticDimension
        self.chatWall.separatorStyle = .None
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        channel.subscribeUser(inView: self)
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        deregisteKeyboardWizard()
        channel.unsubscribeUser(fromView: self)
    }
    
    // MARK: - 📬 Receive and display messages
    
    func displayNewMessage(notification: NSNotification) {
        
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
