//
//  SCIndexedEntity+CoreDataClass.swift
//  Make
//
//  Created by Richmond Starbuck on 12/18/16.
//
//

import Foundation
import CoreData


public class SCIndexedEntity: NSManagedObject {
    public class func entityName() -> String {
        return "IndexedEntity"
    }

    
    public var id: String? {
        get {
            return coreDataGetter("id", in: self)
        }
        set {
            coreDataSetter("id", value: newValue, in: self)
        }
    }
    
    //@NSManaged public var id: String?

    
    override public func awakeFromInsert() {
        self.id = UUID().uuidString
    }
}
