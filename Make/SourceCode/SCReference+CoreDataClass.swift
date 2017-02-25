//
//  SCReference+CoreDataClass.swift
//  Make
//
//  Created by Richmond Starbuck on 2/25/17.
//
//

import UIKit
import CoreData


public class SCReference: NSManagedObject {
    public static let entityName = "Reference"
    
    
    @NSManaged public var id: String
    @NSManaged public var positionX: Double
    @NSManaged public var positionY: Double
    @NSManaged public var scale: Double
    @NSManaged public var rotation: Double
    @NSManaged public var sprite: SCSprite
    @NSManaged public var scene: SCScene
    
    
    public override func awakeFromInsert() {
        self.id = UUID().uuidString
    }
    
}
