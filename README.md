
What is it?
===========
Uchat is a simple iOS chat app written in Swift. It was build as my final project for the [Udacity iOS Developer nanodegree](https://www.udacity.com/nanodegree). 

Basic functionality
===================
Users need Udacity credentials to login. After authenticating they can select a chat channel to join from a list that corresponds to the courses they are enrolled in at Udacity. After entering a channel user can send messages to other participants, similarly to an IRC type of interaction.

Getting Started
===============
In order to get this app working you will need to first jump over couple of hurdles:

1. Set up a standalone [Parse server](https://github.com/ParsePlatform/parse-server) (for push notifications only)
2. Obtain the Apple SSL certificate for your copy of the app and the provisioning profile for your devices. There is a tutorial [here](https://github.com/ParsePlatform/PushTutorial/tree/master/iOS).

Uchat uses the Parse server for push notifications. I have deployed my own standalone server on Heroku, following a guide on [medium.com](https://medium.com/@timothy_whiting/setting-up-your-own-parse-server-568ee921333a#.33qq3k3hx). If you are an Udacity student please contact me if you'd like to use my server for tests.

Once you have the certificates and the server setup you can proceed with the installation.

Installation
============
## Download repository

`git clone https://github.com/wosheesh/uchatclient`

Parse SDK is already added to the repo in *Supporting Files/Frameworks* directory.

## Setup environmental variables for Parse
You need to specify your PARSE_APP_ID, PARSE_SERVER, PARSE_CLIENT_KEY **and** PARSE_MASTER_KEY. This can be done in `ParseConstants.swift`:

    struct Environment {
        static let PARSE_APP_ID: String = envDict["PARSE_APP_ID"]!
        static let PARSE_MASTER_KEY: String = envDict["PARSE_MASTER_KEY"]!
        static let PARSE_SERVER: String = envDict["PARSE_SERVER"]!
        static let PARSE_CLIENT_KEY: String = envDict["PARSE_CLIENT_KEY"]!
    }

You can change the above to your settings or set the actual variables by [editing the Xcode scheme](http://nshipster.com/launch-arguments-and-environment-variables/).
> Uchat **requires your Parse's server master key** in order to enable client-push. Distributing an app with a master key is not generally recommended. More on "dangers" of client push [here](http://blog.parse.com/learn/engineering/the-dangerous-world-of-client-push/).

Comments on the code
====================
There are few aspects of the code that might be of interest from a learning perspective. I've outlined them here to crystalise my own understanding. Hopefully you'll find them useful, especially if you're a beginning iOS developer.

## Push notifications
Uchat uses Apple Push Notification service (APNs) for sending and receiving chat messages. I've considered other solutions for peer to peer communication, but at this stage I wanted to focus on the client side of things, and majority of alternatives required much more back-end work. 

### Registration for APNs
Following steps are executed before any app can receive and send remote notifications:

![alt text](https://github.com/wosheesh/uchatclient/blob/master/Img/RemoteNotifRegistration.png?raw=true "Remote Notification Registration")

Registration starts with the AppDelegate calling the `registerForRemoteNotifications()`  method.  As far as I understand this happens every time an app launches. That's in order to keep the tokens up to date.
> Note that uchat doesn't require users to enable notifications. All notifications are delivered in the background with no Badges, Sounds or Alerts. That's why `application:registerUserNotificationSettings` is not being called during registration.

Upon receiving a device token from APNs the AppDelegate calls `application:didRegisterForRemoteNotificationsWithDeviceToken`. The token is then passed to the Parse server:

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()

At this point the server and the app are both registered with the APNs. 
The token is like a phone number. It allows APNs to track the device for which a notification is being sent, and to identify where the notifications came from. 

### Subscription to a channel
User needs to be subscribed to a channel in order to send and receive messages. User gets automatically subscribed to a channel when `ChatViewController` is instantiated, and then unsubscribed when the `viewWillDisappear` is called. Users can only be subscribed to one channel at a time. 
Channel subscription process is described here:

![alt text](https://github.com/wosheesh/uchatclient/blob/master/Img/SubscribingToAChannel.png?raw=true "Subscribing to a channel")

The local notification "newMessage"  is used to pass the payload of the remote notification inside the app. So in effect uchat uses *remote notifications* to push messages to other devices, and *local notifications* to distribute them to the appropriate view controller while app is active. This will be covered in the next section on data persistency.

### Sending and receiving notifications
Uchat uses REST API to communicate with the Parse server to send new chat messages as remote push notifications:

![alt text](https://github.com/wosheesh/uchatclient/blob/master/Img/SendingMessagesAsPushNotifs.png?raw=true "Remote Notification Registration")

The Parse server then establishes a TLS connection with APNs following the [APNs API](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/APNsProviderAPI.html#//apple_ref/doc/uid/TP40008194-CH101-SW1) protocol. 
> Parse allows to group users by the [channel parameter](https://parse.com/docs/ios/guide#push-notifications-using-channels). Uchat relies on this to send messages only to the participants of the currently subscribed "chat room".

The server has the tokens of devices grouped by channels. It makes copies of the original message, addresses them to devices in the selected channel, and sendss them one by one to APNs. APNs then finally pushes them as notifications. If the original user is still in the channel, she will then see the message appear in her chat.

## Persistency of data
Uchat stores the following data persistently:

1. For each app user: currently enrolled courses and history of messages from each channel in **CoreData**
2. For currently logged-in user: email and password in **Keychain** 
3. For all users: one copy of the Udacity course catalogue from [Udacity API](https://www.udacity.com/catalog-api).

## CoreData

A lot of ideas for integrating CoreData came from the book by Florian Kugler and Daniel Eggert: "Core Data" available at [objc.io](https://objc.io) - highly recommended for all iOS developers. Below are some highlights.

### Model
Uchat has a relatively simple model with 2 entities: Channel and Message in a one-to-many relationship:

![alt text](https://github.com/wosheesh/uchatclient/blob/master/Img/Uchat_Model.png?raw=true "Uchat Model")

What's more interesting are the CoreData protocols and helpers introduced by Florian and Daniel in their book, and which I have integrated into the app:

#### CoreData Stack
Rather than accessing the context through a Singleton object, one `NSManagedObjectContext` is setup after a successful user login, and then it is passed by the `LoginViewController` to the next view controller, and so forth. A view that wants to access the context need to comply with this protocol:

    protocol ManagedObjectContextSettable: class {
    var managedObjectContext: NSManagedObjectContext! { get set }
    }
    
Passing the context is done in `prepareForSegue(_:)`. This way we make sure that once one context is initialised it will continue to be used in a very controlled way, and only by classes that we choose. It also avoids using a singleton object for the CoreData Stack, making room for an easier implementation of multiple contexts in the future.

#### CoreData helpers and protocols
To keep the CoreData code easy to maintain few helpers and protocols are introduced, notably: 

##### - `ManagedObjectType` 
This is a protocol around each `NSManagedEntity`, intendent to make it more convenient for running fetch requests in a standardised way across the app, but can be further extended to other methods that we may need for convenience.

##### - `DataProvider`
Rather than implementing the `NSFetchedResultController` boilerplate code in each view that needs to display CoreData updates, a new reusable class `FetchedResultsDataProvider` is introduced which acts as `NSFetchedResultsControllerDelegate` and adheres to a `DataProvider` protocol. This protocol allows the class to be generic over the `Object` that is being updated.
The `FetchedResultsDataProvider` gathers all changes reported from the `NSFetchedResultController` and sends them to its delegate through `controllerDidChangeContent(_:)`. In our case the delegate in each case is a `UIViewController` with a `UITableView`.

##### - `DataSource`
`UITableViewDataSource` class is wrapped into the `TableViewDataSource` - in a similar fashion as above. The new class encapsulates the usual boiler plate code for updating `tableView`. It exposes the `processUpdates(_:)` method to receive updates from the `DataProvider` and its `controllerDidChangeContent(_:)`.

`FetchedResultsDataProvider` and `TableViewDataSource` come together in the delegate methods of `DataProvider` and `DataSource`. For example for the `Message` object and the corresponding `ChatViewController` it looks like this:

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
By introducing the `DataSource` and `DataProvider` protocols and the `FetchedResultsDataProvider` and `TableViewDataSource` classes, the above code is the only "boilerplate" we need to write for any kind of TableView that needs to be updated with CoreData context changes. Here's a high-level diagram from the book explaining how these methods work together:

![alt text](https://github.com/wosheesh/uchatclient/blob/master/Img/FetchedResultController.png?raw=true "Fetched Results Data Provider")

I found this solution a very clean way to keep code and CoreData organised. For a simple app like this it may look like overkill, but debugging CoreData can be a very tedious process, and I found that with this approach it was much easier.

### CoreData's interaction with Push Notifications
Once the user's currently enrolled courses are matched with udacity's catalogue and channels are created in CoreData, the user can start chatting. Following is an explanation on how the model and the push system work together in `ChatViewController`:

![alt text](https://github.com/wosheesh/uchatclient/blob/master/Img/SendingANewMessageAndCoreData.png?raw=true "Sending messages and updating CoreData")

The actual process is simpler than it would seem from the above diagram. Perhaps the most important aspect is how the messages get translated from push notifiations to Message entities and vice-versa:
#### Sending a message and CoreData:
1. User creates a new message body and touches the send button in `ChatViewController`
2. A new Message entity is instantiated in the context through `Message:insertIntoContext:`. At this stage the message's `receivedAt: String?` property is nil.
3. A JSON object is created out of the message's properties by `Message:send:`
4. The JSON is forwarded by `ParseClient:push:` to the server. The notification payload is sent by the server to the APNs and converted to a push message.

>The `ChatViewController` only displays messages which have `receivedAt != nil`. So a new `Message` at this stage is in the context and the model, but doesn't yet appear to the user. 

#### Receiving a message and CoreData
1. Upon receiveing a remote notification the  `application:didReceiveRemoteNotification:` method is called in the AppDelegate.
2. A local notification **"newMessage"** is triggered with the remote notification's `userInfo`  and passed to the `ChatViewController` which calls `Message:createFromPushNotification`.
3. `Message:createFromPushNotification:` parses the userInfo as JSON and either creates a new Message entity and saves it into context, or updates an existing message by changing its receivedAt date to current time.
4. The message is displayed by  `ChatViewController`.

Known Issues
============

 - The textView controller in ChatViewController doesn't always gets its height properly
 - Channel titles and subtitles may need more space in their cells



Licensing
=========



Contact
=======
You can find me on [twitter](https://twitter.com/wmaterka) to catchup or contact me through github if you need any help with the code.

---
PS.:
====
If you are looking to implement a messaging functionality I recommend you also have a look at [OneSignal](https://onesignal.com). I've implemented their solution and works just as well or better than Parse. Another solution is to try out [twilio's IP messaging](https://www.twilio.com/ip-messaging) that is currently in beta. I found it very easy to setup, but requires more customisation server-side. There are plenty more providers out there, I am just listing the ones I have actually tried before settling on Parse. I chose Parse stand-alon mostly because of its other functionality, and also because of the amount of information and size of the community, despite the fact that is being discontinued.