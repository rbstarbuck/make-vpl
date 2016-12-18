//
//  SCVariable+CoreDataProperties.swift
//  Make
//
//  Created by Richmond Starbuck on 12/18/16.
//
//

import Foundation
import CoreData


extension SCVariable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SCVariable> {
        return NSFetchRequest<SCVariable>(entityName: "Variable");
    }

    @NSManaged public var data: NSObject?
    @NSManaged public var definition: SCClass?

}
