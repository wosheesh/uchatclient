//
//  NSManagedObjectContext+Extensions.swift
//  uchat
//
//  Created by Wojtek Materka on 01/03/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {
    
    /// Insert new ManagedObject into context using ManagedObjectType.entityName
    public func insertObject<A: ManagedObject where A: ManagedObjectType>() -> A {
        
        //This saves us downcasting and identifying entity name every time
        guard let obj = NSEntityDescription.insertNewObjectForEntityForName(A.entityName, inManagedObjectContext: self) as? A else { fatalError("Wrong object type") }
        return obj
        
    }
    
    public func saveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch {
            print("🙄 Rolling back Context")
            // abandon unsaved data (ok in single contexts...)
            rollback()
            return false
        }
    }
    
    /// Wrapper for changes to ManagedObjectContext. Makes sure all changes are wrapped in an asynchronous queue.
    public func performChanges(block: () -> ()) {
        performBlock {
            block()
            self.saveOrRollback()
        }
    }
    
}
