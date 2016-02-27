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
        
//        // Enable storing and querying data from Local Datastore.
//        // Remove this line if you don't want to use Local Datastore features or want to use cachePolicy.
//        Parse.enableLocalDatastore()
//        

        // Initialize Parse
        Parse.initializeWithConfiguration(ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) -> Void in
            configuration.applicationId = "uchatapp" as String
            configuration.clientKey = "8022802" as String
            configuration.server = "https://intense-river-39239.herokuapp.com/parse" as String
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
        
//         Register for notifications
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
        NSLog("📬  \(__FUNCTION__): application received a message: \(userInfo)")
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
                print("cvc: \(currentViewController)")
                if currentViewController.isKindOfClass(ChatViewController) {
                    print("cvc through")
                    NSNotificationCenter.defaultCenter().postNotificationName("newMessage", object: userInfo)
                    
                    print(" message userinfo: \(userInfo.description)")

                }
            }
            
        }
        
        //TODO: change for sending pictures
//        completionHandler(UIBackgroundFetchResult.NoData)
    }
    
    
    // MARK: - 🔂 Application State management

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
    
    // MARK: - 🐵 Helpers
    
    /// Loops through the view hierarchy and returns the last view found, which is the active view.
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
    
    
    
    // Returns the most recently presented UIViewController (visible)
//    class func getCurrentViewController() -> UIViewController? {
//        
//        // If the root view is a navigation controller, we can just return the visible ViewController
//        if let navigationController = getNavigationController() {
//            return navigationController.visibleViewController
//        }
//        
//        // Otherwise, we must get the root UIViewController and iterate through presented views
//        if let rootController = UIApplication.sharedApplication().keyWindow?.rootViewController {
//            var currentController: UIViewController! = rootController
//            
//            // Each ViewController keeps track of the view it has presented, so we
//            // can move from the head to the tail, which will always be the current view
//            while( currentController.presentedViewController != nil ) {
//                currentController = currentController.presentedViewController
//            }
//            
//            return currentController
//        }
//        return nil
//    }
    
    // Returns the navigation controller if it exists
//    class func getNavigationController() -> UINavigationController? {
//        
//        if let navigationController = UIApplication.sharedApplication().keyWindow?.rootViewController  {
//            
//            return navigationController as? UINavigationController
//        }
//        return nil
//    }


}

