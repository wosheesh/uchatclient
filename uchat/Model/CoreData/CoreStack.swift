//
//  CoreStack.swift
//  uchat
//
//  Created by Wojtek Materka on 01/03/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import CoreData
import Foundation


private let StoreURL = NSURL.documentsURL.URLByAppendingPathComponent("uchat.sqlite")

public func createUchatMainContext() -> NSManagedObjectContext {
    let bundles = [NSBundle(forClass: Channel.self), NSBundle(forClass: Message.self)]
    
    guard let model = NSManagedObjectModel.mergedModelFromBundles(bundles) else {
        fatalError("🆘 model not found")
    }
    
    let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
    try! psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: StoreURL, options: nil)
    
    let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    return context
}