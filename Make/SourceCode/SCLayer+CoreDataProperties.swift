//
//  SCLayer+CoreDataProperties.swift
//  Make
//
//  Created by Richmond Starbuck on 12/20/16.
//
//

import UIKit
import CoreData


extension SCLayer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SCLayer> {
        return NSFetchRequest<SCLayer>(entityName: "Layer");
    }

    @NSManaged public var name: String?
    @NSManaged public var image: UIImage?
    @NSManaged public var frame: SCFrame?

}
