//
//  SCLayer+CoreDataProperties.swift
//  Make
//
//  Created by Richmond Starbuck on 12/23/16.
//
//

import Foundation
import CoreData


extension SCLayer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SCLayer> {
        return NSFetchRequest<SCLayer>(entityName: "Layer");
    }

}
