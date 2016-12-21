//
//  SCScene+CoreDataProperties.swift
//  Make
//
//  Created by Richmond Starbuck on 12/20/16.
//
//

import Foundation
import CoreData


extension SCScene {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SCScene> {
        return NSFetchRequest<SCScene>(entityName: "Scene");
    }

    @NSManaged public var world: SCWorld?

}
