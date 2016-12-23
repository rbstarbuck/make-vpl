//
//  SCNamedEntity+CoreDataClass.swift
//  Make
//
//  Created by Richmond Starbuck on 12/18/16.
//
//

import Foundation
import CoreData


public class SCNamedEntity: SCIndexedEntity {
    override public class func entityName() -> String {
        return "NamedEntity"
    }
    
    //@NSManaged public var name: String?
    //@NSManaged public var comment: String?
    
    public var name: String? {
        get {
            return coreDataGetter("name", in: self)
        }
        set {
            coreDataSetter("name", value: newValue, in: self)
        }
    }
    
    public var comment: String? {
        get {
            return coreDataGetter("comment", in: self)
        }
        set {
            coreDataSetter("comment", value: newValue, in: self)
        }
    }
    
}
