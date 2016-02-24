//
//  AppDelegate.swift
//  uchat
//
//  Created by Wojtek Materka on 20/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

// TODO: distinguish between channel subscriptions and user tags

import UIKit
import Foundation
//import Parse

//Load env variables
let envDict = NSProcessInfo.processInfo().environment

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var oneSignal: OneSignal?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        oneSignal = OneSignal(launchOptions: launchOptions, appId: "53a32274-2cd6-4e31-a835-121883f0fee1") { (message, additionalData, isActive) in
            print("📬 OneSignal Notification opened:\nMessage: %@", message)
            
            if additionalData != nil {
                print("> additionalData: %@", additionalData)
                
                // Check for and read any custom values you added to the notification
                // This done with the "Additonal Data" section the dashbaord.
                // OR setting the 'data' field on our REST API.
                if let customKey = additionalData["customKey"] as! String? {
                    print("> customKey: %@", customKey)
                }
            }
            
            
            
        }
        
        OneSignal.defaultClient().enableInAppAlertNotification(false)
        
//        oneSignal!.IdsAvailable({ (userId, pushToken) in
//            NSLog("UserId:%@", userId);
//            if (pushToken != nil) {
//                NSLog("Sending Test Noification to this device now");
//                self.oneSignal!.postNotification(["contents": ["en": "Test Message"], "include_player_ids": [userId]]);
//            }
//        });
        
//        // Enable storing and querying data from Local Datastore.
//        // Remove this line if you don't want to use Local Datastore features or want to use cachePolicy.
//        Parse.enableLocalDatastore()
//        
//        // Initialize Parse
//        Parse.initializeWithConfiguration(ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) -> Void in
//            configuration.applicationId = envDict["PARSE_APP_ID"]! as String
//            configuration.clientKey = envDict["PARSE_CLIENT_KEY"]! as String
//            configuration.server = envDict["PARSE_SERVER"]! as String
//        }))
//        
//        
//        PFUser.enableAutomaticUser()
//        
//        let defaultACL = PFACL();
//        
//        // If you would like all objects to be private by default, remove this line.
//        defaultACL.publicReadAccess = true
//        
//        PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser: true)
//        
//        if application.applicationState != UIApplicationState.Background {
//            // Track an app open here if we launch with a push, unless
//            // "content_available" was used to trigger a background push (introduced in iOS 7).
//            // In that case, we skip tracking here to avoid double counting the app-open.
//            
//            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
//            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
//            var noPushPayload = false;
//            if let options = launchOptions {
//                noPushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil;
//            }
//            if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
//                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
//            }
//        }
//        
//        log.info("Parse initialized ✅")
        
        // Register for notifications
//        let notificationTypes: UIUserNotificationType = [.Alert, .Badge, .Sound]
//        let notificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
//        
//        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
//        
//        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        

        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
//        let installation = PFInstallation.currentInstallation()
//        installation.setDeviceTokenFromData(deviceToken)
//        installation.saveInBackground()
//        
//        PFPush.subscribeToChannelInBackground("") { (succeeded: Bool, error: NSError?) in
//            if succeeded {
//                print("Successfully subscribed to push notifications on the broadcast channel. 📨 ✅ \n");
//            } else {
//                print("🆘 📨 Failed to subscribe to push notifications on the broadcast channel with error = \(error)")
//            }
//        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("📵 📨 Push notifications are not supported in the iOS Simulator.\n")
        } else {
            print("🆘 📨 application:didFailToRegisterForRemoteNotificationsWithError: \(error)")
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
//        PFPush.handlePush(userInfo)
//        if application.applicationState == UIApplicationState.Inactive {
//            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
//        }
    }
    
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

