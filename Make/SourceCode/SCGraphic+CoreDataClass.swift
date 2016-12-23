//
//  SCGraphic+CoreDataClass.swift
//  Make
//
//  Created by Richmond Starbuck on 12/20/16.
//
//

import Foundation
import CoreData


public class SCGraphic: SCNamedEntity {
    override public class func entityName() -> String {
        return "Graphic"
    }
    
    
    @NSManaged public var frames: Set<SCFrame>
    @NSManaged public var world: SCWorld
    @NSManaged public var sprites: Set<SCSprite>?
    
    
    public var connector: SCConnector {
        get {
            return self.world.connector
        }
    }
    
    
    @discardableResult
    public func createFrame() -> SCFrame? {
        if let frame: SCFrame = self.connector.createEntity(SCFrame.entityName()) {
            self.addToFrames(frame)
            frame.createLayer()
            return frame
        }
        return nil
    }
}
