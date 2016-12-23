//
//  SCLayer+CoreDataProperties.swift
//  Make
//
//  Created by Richmond Starbuck on 12/21/16.
//
//

import UIKit
import CoreData


extension SCLayer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SCLayer> {
        return NSFetchRequest<SCLayer>(entityName: "Layer");
    }


}
