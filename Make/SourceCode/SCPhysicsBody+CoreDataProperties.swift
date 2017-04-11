//
//  SCPhysicsBody+CoreDataProperties.swift
//  Make
//
//  Created by Richmond Starbuck on 1/18/17.
//
//

import Foundation
import CoreData


extension SCPhysicsBody {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SCPhysicsBody> {
        return NSFetchRequest<SCPhysicsBody>(entityName: "PhysicsBody");
    }
    

}
