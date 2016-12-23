//
//  SCMethod+CoreDataClass.swift
//  Make
//
//  Created by Richmond Starbuck on 12/18/16.
//
//

import Foundation
import CoreData


public class SCMethod: SCNamedEntity {
    override public class func entityName() -> String {
        return "Method"
    }
    
    
    @NSManaged public var code: SCBlock
    @NSManaged public var definition: SCClass

}
