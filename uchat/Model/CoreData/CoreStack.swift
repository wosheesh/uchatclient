//
//  CoreStack.swift
//  uchat
//
//  Created by Wojtek Materka on 01/03/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import CoreData
import Foundation


public func createUchatMainContext() -> NSManagedObjectContext {
    let StoreURL = NSURL.documentsURL.URLByAppendingPathComponent("uchat_" + UdacityUser.udacityKey! + ".sqlite")
    let bundles = [NSBundle(forClass: Channel.self), NSBundle(forClass: Message.self)]
    
    guard let model = NSManagedObjectModel.mergedModelFromBundles(bundles) else {
        fatalError("🆘 model not found")
    }
    
    let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
    do {
        try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: StoreURL, options: nil)
        print(" ✅ PSC initialised with db at: \(StoreURL)")
    } catch {
        // Report any error we got.
        var dict = [String: AnyObject]()
        let failureReason = "There was an error creating or loading the application's saved data."
        dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
        dict[NSLocalizedFailureReasonErrorKey] = failureReason
        
        dict[NSUnderlyingErrorKey] = error as NSError
        let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog("🆘 💾 Unresolved error \(wrappedError), \(wrappedError.userInfo)")
        abort()
    }
    
    let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    context.persistentStoreCoordinator = psc
    
    print("NSManagedObjectContext init ✅")
    return context
}