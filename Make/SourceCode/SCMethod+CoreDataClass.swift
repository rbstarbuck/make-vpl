//
//  SCMethod+CoreDataClass.swift
//  Make
//
//  Created by Richmond Starbuck on 12/18/16.
//
//

import Foundation
import CoreData


public class SCMethod: NSManagedObject {
    public static let entityName = "Method"
    
    
    @NSManaged public var code: SCBlock
    @NSManaged public var name: String
    
}
