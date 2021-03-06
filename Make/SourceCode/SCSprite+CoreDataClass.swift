//
//  SCSprite+CoreDataClass.swift
//  Make
//
//  Created by Richmond Starbuck on 12/18/16.
//
//

import UIKit
import CoreData


public class SCSprite: NSManagedObject, SCNamedEntity {
    public static let entityName = "Sprite"

    
    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var dateCreated: Date
    @NSManaged public var graphic: SCGraphic?
    @NSManaged public var methods: Set<SCMethod>
    @NSManaged public var references: Set<SCReference>
    @NSManaged public var variables: Set<SCVariable>
    @NSManaged public var world: SCWorld
    @NSManaged public var physicsBody: SCPhysicsBody
    
    
    var editorImage: UIImage {
        get {
            if let graphic = self.graphic {
                return graphic.firstFrame.makeImageFromLayers()
            }
            else {
                return UIImage(named: "Placeholder image")!
            }
        }
    }
    
    
    override public func awakeFromInsert() {
        self.id = UUID().uuidString
        self.dateCreated = Date()
    }
    
    
    @discardableResult
    public func createMethod() -> SCMethod {
        let method: SCMethod = self.world.connector.createEntity(SCMethod.entityName)!
        method.name = "\(SCConstants.METHOD_DISPLAY_TITLE) \(self.methods.count + 1)"
        self.addToMethods(method)
        return method
    }
    
    @discardableResult
    public func createVariable() -> SCVariable {
        let variable: SCVariable = self.world.connector.createEntity(SCVariable.entityName)!
        variable.name = "\(SCConstants.VARIABLE_DISPLAY_TITLE) \(self.variables.count + 1)"
        self.addToVariables(variable)
        return variable
    }
    
    @discardableResult
    public func createReference(in scene: SCScene) -> SCReference {
        let reference: SCReference = self.world.connector.createEntity(SCReference.entityName)!
        self.addToReferences(reference)
        scene.addToReferences(reference)
        return reference
    }
    
}
