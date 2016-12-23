//
//  SCClass+CoreDataClass.swift
//  Make
//
//  Created by Richmond Starbuck on 12/18/16.
//
//

import Foundation
import CoreData


public class SCClass: SCNamedEntity {
    override public class func entityName() -> String {
        return "Class"
    }
    
    
    //@NSManaged public var methods: Set<SCMethod>?
    //@NSManaged public var variables: Set<SCVariable>?
    
    public var methods: Set<SCMethod>? {
        get {
            return coreDataGetter("methods", in: self)
        }
        set {
            coreDataSetter("methods", value: newValue, in: self)
        }
    }
    
    public var variables: Set<SCVariable>? {
        get {
            return coreDataGetter("name", in: self)
        }
        set {
            coreDataSetter("name", value: newValue, in: self)
        }
    }
    

}
