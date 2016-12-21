//
//  SCSprite+CoreDataProperties.swift
//  Make
//
//  Created by Richmond Starbuck on 12/20/16.
//
//

import Foundation
import CoreData


extension SCSprite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SCSprite> {
        return NSFetchRequest<SCSprite>(entityName: "Sprite");
    }

    @NSManaged public var graphic: SCGraphic?
    @NSManaged public var world: SCWorld?

}
