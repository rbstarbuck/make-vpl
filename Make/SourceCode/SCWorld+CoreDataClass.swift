//
//  SCWorld+CoreDataClass.swift
//  Make
//
//  Created by Richmond Starbuck on 12/18/16.
//
//

import Foundation
import CoreData


public class SCWorld: SCClass {
    override public class func entityName() -> String {
        return "World"
    }
    
    
    public var connector: SCConnector!
    
    //@NSManaged public var graphics: Set<SCGraphic>?
    //@NSManaged public var scenes: Set<SCScene>?
    //@NSManaged public var sprites: Set<SCSprite>?
    
    public var graphics: Set<SCGraphic>? {
        get {
            return coreDataGetter("graphics", in: self)
        }
        set {
            coreDataSetter("graphics", value: newValue, in: self)
        }
    }
    
    public var scenes: Set<SCScene>? {
        get {
            return coreDataGetter("scenes", in: self)
        }
        set {
            coreDataSetter("scenes", value: newValue, in: self)
        }
    }
    
    public var sprites: Set<SCSprite>? {
        get {
            return coreDataGetter("sprites", in: self)
        }
        set {
            coreDataSetter("sprites", value: newValue, in: self)
        }
    }
    
    
    @discardableResult
    public func createGraphic() -> SCGraphic? {
        if let graphic: SCGraphic = self.connector.createEntity(SCGraphic.entityName()) {
            self.addToGraphics(graphic)
            graphic.createFrame()
            return graphic
        }
        return nil
    }
    
    @discardableResult
    public func createScene() -> SCScene? {
        if let scene: SCScene = self.connector.createEntity(SCScene.entityName()) {
            self.addToScenes(scene)
            return scene
        }
        return nil
    }
    
    @discardableResult
    public func createSprite() -> SCSprite? {
        if let sprite: SCSprite = self.connector.createEntity(SCSprite.entityName()) {
            self.addToSprites(sprite)
            return sprite
        }
        return nil
    }
}
