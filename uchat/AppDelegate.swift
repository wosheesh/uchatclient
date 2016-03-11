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

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        // Initialize Parse
        Parse.initializeWithConfiguration(ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) -> Void in
            configuration.applicationId = ParseClient.Environment.PARSE_APP_ID
            configuration.clientKey = ParseClient.Environment.PARSE_CLIENT_KEY
            configuration.server = ParseClient.Environment.PARSE_SERVER
        }))
        
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
        
        if application.applicationState == UIApplicationState.Inactive {
            NSLog("Notification received while app was inactive")
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
        }
        
        print("\(__FUNCTION__) reports that a new message was received")
        
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

