//
//  SCWorld+CoreDataClass.swift
//  Make
//
//  Created by Richmond Starbuck on 12/18/16.
//
//

import Foundation
import CoreData


@objc
public enum GravityDirection: Int32 {
    case down = 0, left, right, up;
}


public class SCWorld: NSManagedObject, SCNamedEntity {
    public static let entityName = "World"
    public static let graphicObserverKey = "World->>Graphic"
    public static let spriteObserverKey = "World->>Sprite"

    
    public var connector: SCConnector!
    
    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var initialScene: String
    @NSManaged public var gravityDirection: GravityDirection
    @NSManaged public var graphics: Set<SCGraphic>
    @NSManaged public var scenes: Set<SCScene>
    @NSManaged public var sprites: Set<SCSprite>
    @NSManaged public var methods: Set<SCMethod>
    @NSManaged public var variables: Set<SCVariable>
    
    
    public lazy var graphicObserver: ObservableEntity = {
        let observer = ObservableEntity(key: SCWorld.graphicObserverKey,
                                        entity: SCGraphic.entityName,
                                        context: self.connector.context)
        observer.predicate = NSPredicate(format: "world == %@", self)
        observer.sortDescriptors.append(NSSortDescriptor(key: "dateCreated", ascending: false))
        observer.startObserving()
        return observer
    }()
    
    public lazy var spriteObserver: ObservableEntity = {
        let observer = ObservableEntity(key: SCWorld.spriteObserverKey,
                                        entity: SCSprite.entityName,
                                        context: self.connector.context)
        observer.predicate = NSPredicate(format: "world == %@", self)
        observer.sortDescriptors.append(NSSortDescriptor(key: "dateCreated", ascending: false))
        observer.startObserving()
        return observer
    }()
    
    
    override public func awakeFromInsert() {
        self.id = UUID().uuidString
        self.name = "Hello World!"
    }
    
    @discardableResult
    public func createGraphic() -> SCGraphic {
        let graphic: SCGraphic = self.connector.createEntity(SCGraphic.entityName)!
        graphic.name = "\(SCConstants.GRAPHIC_DISPLAY_TITLE) \(self.graphics.count + 1)"
        self.addToGraphics(graphic)
        graphic.createFrame()
        return graphic
    }
    
    @discardableResult
    public func createScene() -> SCScene {
        let scene: SCScene = self.connector.createEntity(SCScene.entityName)!
        scene.name = "\(SCConstants.SCENE_DISPLAY_TITLE) \(self.scenes.count + 1)"
        self.addToScenes(scene)
        return scene
    }
    
    @discardableResult
    public func createSprite() -> SCSprite {
        let sprite: SCSprite = self.connector.createEntity(SCSprite.entityName)!
        sprite.name = "\(SCConstants.SPRITE_DISPLAY_TITLE) \(self.sprites.count + 1)"
        sprite.physicsBody = self.connector.createEntity(SCPhysicsBody.entityName)!
        self.addToSprites(sprite)
        return sprite
    }
    
    @discardableResult
    public func createMethod() -> SCMethod {
        let method: SCMethod = self.connector.createEntity(SCMethod.entityName)!
        method.name = "\(SCConstants.METHOD_DISPLAY_TITLE) \(self.methods.count + 1)"
        self.addToMethods(method)
        return method
    }
    
    @discardableResult
    public func createVariable() -> SCVariable {
        let variable: SCVariable = self.connector.createEntity(SCVariable.entityName)!
        variable.name = "\(SCConstants.VARIABLE_DISPLAY_TITLE) \(self.variables.count + 1)"
        self.addToVariables(variable)
        return variable
    }
    
}
