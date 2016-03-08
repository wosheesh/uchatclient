//
//  AppDelegate.swift
//  uchat
//
//  Created by Wojtek Materka on 20/02/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import UIKit
import Foundation
import Parse


//Load env variables
let envDict = NSProcessInfo.processInfo().environment

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
//    let managedObjectContext = createUchatMainContext()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        // Initialize Parse
        Parse.initializeWithConfiguration(ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) -> Void in
            configuration.applicationId = "uchatapp"
            configuration.clientKey = "8022802"
            configuration.server = "https://intense-river-39239.herokuapp.com/parse"
        }))
        
        

        
        PFUser.enableAutomaticUser()
        
        let defaultACL = PFACL();
        
        // If you would like all objects to be private by default, remove this line.
        defaultACL.publicReadAccess = true
        
        PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser: true)
        
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var noPushPayload = false;
            if let options = launchOptions {
                noPushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil;
            }
            if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
        
        print("Parse initialized ✅")
        
        // Register for notifications
        let notificationTypes: UIUserNotificationType = [.Alert, .Badge, .Sound]
        let notificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
        
        PFPush.subscribeToChannelInBackground("") { (succeeded: Bool, error: NSError?) in
            if succeeded {
                print("Successfully subscribed to push notifications on the broadcast channel. 📨 ✅ \n");
            } else {
                print("🆘 📨 Failed to subscribe to push notifications on the broadcast channel with error = \(error)")
            }
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("📵 📨 Push notifications are not supported in the iOS Simulator.\n")
        } else {
            print("🆘 📨 application:didFailToRegisterForRemoteNotificationsWithError: \(error)")
        }
    }
    
    // MARK: - 📩 Handle received notifications
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
//        NSLog("📬  \(__FUNCTION__): application received a message: \(userInfo)")
//        PFPush.handlePush(userInfo)
        
        if application.applicationState == UIApplicationState.Inactive {
            NSLog("Notification received while app was inactive")
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
        
        // Handle push while app is active
        if application.applicationState == UIApplicationState.Active {
            NSLog("Notification received while app was Active")
            guard let rootViewController = self.window?.rootViewController else {
                print("root")
                return
            }
            
            if let currentViewController = getCurrentViewController(rootViewController) {
                if currentViewController.isKindOfClass(ChatViewController) {
                    NSNotificationCenter.defaultCenter().postNotificationName("newMessage", object: userInfo)
                    print(" 📬 new message received with userinfo: \(userInfo)")

                }
            }
            
        }
        
        // for now we are not sending any data with notifs
        completionHandler(UIBackgroundFetchResult.NoData)
    }

    
    func getCurrentViewController(vc: UIViewController) -> UIViewController? {
        // Presented
        if let pvc = vc.presentedViewController {
            return getCurrentViewController(pvc)
        }
            // Split?
        else if let svc = vc as? UISplitViewController where svc.viewControllers.count > 0 {
            return getCurrentViewController(svc.viewControllers.last!)
        }
            // Nav?
        else if let nc = vc as? UINavigationController where nc.viewControllers.count > 0 {
            return getCurrentViewController(nc.topViewController!)
        }
            // Tab?
        else if let tbc = vc as? UITabBarController {
            if let svc = tbc.selectedViewController {
                return getCurrentViewController(svc)
            }
        }
        // return the last found.
        return vc
    }
    
    

}

