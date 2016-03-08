//
//  ManagedObject.swift
//  uchat
//
//  Created by Wojtek Materka on 01/03/2016.
//  Copyright © 2016 Wojtek Materka. All rights reserved.
//

import CoreData

public class ManagedObject: NSManagedObject {
}

public protocol ManagedObjectType: class {
    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
}

extension ManagedObjectType {
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
    
    public static var sortedFetchRequest: NSFetchRequest {
        let request = NSFetchRequest(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
//        request.predicate = defaultPredicate  // extend the protocol for this 
        return request
    }
    
    
    /// Creates a *sortedFetchRequest* for a *ManagedObjectType* and adds a new predicate to it (keeping the default).
    /// - Returns: NSFetchRequest
//    public static func sortedFetchRequestWithPredicate(predicate: NSPredicate) -> NSFetchRequest {
//        let request = sortedFetchRequest
//        print("running sortedrequestWithPredicate: \(request)")
//        guard let existingPredicate = request.predicate else { fatalError("request must have default predicate") }
//        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [existingPredicate, predicate])
//        return request
//    }
    
}

extension ManagedObjectType where Self: ManagedObject {
    
    /// Helper function that wraps code to fetch or create a new object. If an object isn't found allows for its configuration through a closure and returns a newObject.
    /// - Returns: ManagedObject
    public static func findOrCreateInContext(moc: NSManagedObjectContext,
        matchingPredicate predicate: NSPredicate,
        configure: Self -> ()) -> Self {
            guard let obj = findOrFetchInContext(moc, matchingPredicate: predicate) else {
                let newObject: Self = moc.insertObject()
                configure(newObject)
                return newObject
            }
        return obj
    }

    /// Helper function that checks if the object is already in context (through *materializedObjectInContext*) and returns the object or fetches it through *fetchInContext* closure.
    /// - Returns: ManagedObject
    public static func findOrFetchInContext(moc: NSManagedObjectContext, matchingPredicate predicate: NSPredicate) -> Self? {
        guard let obj = materializedObjectInContext(moc, matchingPredicate: predicate) else {
            return fetchInContext(moc) { request in
                request.predicate = predicate
                request.returnsObjectsAsFaults = false
                request.fetchLimit = 1
            }.first
        }
        return obj
    }
    
    /// Helper function to make fetch requests easier. It combines the configuration, execution and casts the result to correct type.
    /// - Returns: [ManagedObject]
    public static func fetchInContext(context: NSManagedObjectContext,
        @noescape configurationBlock: NSFetchRequest -> () = { _ in }) -> [Self] {
            let request = NSFetchRequest(entityName: Self.entityName)
            configurationBlock(request)
            guard let result = try! context.executeFetchRequest(request) as? [Self] else { fatalError("Fetched objects have wrong type") }
            return result
    }
    
    /// Iterate over all *registeredObjects* known to the context
    /// until it finds one matching the predicate. It only compares to objects that are not faults,
    /// making sure CoreData doesn't check the persistent store, as that would be too costly.
    /// - Returns: ManagedObject?
    public static func materializedObjectInContext(moc: NSManagedObjectContext, matchingPredicate predicate: NSPredicate) -> Self? {
        for obj in moc.registeredObjects where !obj.fault {
            guard let res = obj as? Self where predicate.evaluateWithObject(res) else { continue }
            return res
        }
        return nil
    }
    
    
}