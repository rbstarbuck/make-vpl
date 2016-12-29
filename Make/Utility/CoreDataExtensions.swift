//
//  CoreDataExtensions.swift
//  Make
//
//  Created by Richmond Starbuck on 12/21/16.
//
//

import Foundation
import CoreData


public class CoreDataHelper {
    
    public static func getter<T>(_ key: String, in entity: NSManagedObject, with closure: (()->())? = nil) -> T? {
        entity.willAccessValue(forKey: key)
        closure?()
        let get = entity.primitiveValue(forKey: key) as? T
        entity.didAccessValue(forKey: key)
        return get
    }

    public static func setter<T>(_ key: String, value: T?, in entity: NSManagedObject, with closure: (()->())? = nil) {
        entity.willChangeValue(forKey: key)
        entity.setPrimitiveValue(value, forKey: key)
        closure?()
        entity.didChangeValue(forKey: key)
    }
    
}
