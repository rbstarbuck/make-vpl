//
//  Compiler.swift
//  Make
//
//  Created by Richmond Starbuck on 1/31/17.
//
//

import Foundation
import CoreData
import SpriteKit


class Compiler {
    
    var connector: SCConnector
    
    var graphics = [String: OCGraphic]()
    
    
    init(connector: SCConnector) {
        self.connector = connector
    }
    
}


// Compiler instantiation methods
extension Compiler {
    
    func instantiate(_ scWorld: SCWorld) -> OCWorld {
        let request = NSFetchRequest<SCGraphic>(entityName: SCGraphic.entityName)
        request.predicate = NSPredicate(format: "world = %@", scWorld)
        
        if let graphics = self.connector.fetchEntities(request) {
            for graphic in graphics {
                // TODO: move instantiation to Compiler
                self.graphics[graphic.id] = OCGraphic(from: graphic)
            }
        }
        
        let ocWorld = OCWorld()
        ocWorld.connector = self.connector
        return ocWorld
    }
    
    func instantiate(_ scScene: SCScene, in ocWorld: OCWorld) -> OCScene {
        let ocScene = OCScene()
        ocScene.world = ocWorld
        ocScene.variables.insert(ocWorld.variables)
        
        ocScene.gravityMagnitude = scScene.gravityMagnitude
        ocScene.gravityDirection = scScene.gravityDirection
        
        for variable in scScene.variables {
            self.instantiate(variable, in: ocScene)
        }
        
        return ocScene
    }
    
    func instantiate(_ scVariable: SCVariable, in ocScene: OCScene) {
        switch scVariable.data.type {
        case .reference:
            let data = scVariable.data as! ReferenceVariable
            if let skSprite = self.instantiate(data, in: ocScene) {
                skSprite.name = scVariable.id
                ocScene.addChild(skSprite)
            }
            break
            
        case .number: break
        case .string: break
        case .boolean: break
        }
        
    }
    
    func instantiate(_ scPhysicsBody: SCPhysicsBody, in skSprite: SKSpriteNode) {
        let physicsBody = scPhysicsBody.shape.instantiate(for: skSprite)
        
        physicsBody.isDynamic = scPhysicsBody.isDynamic
        physicsBody.affectedByGravity = scPhysicsBody.isAffectedByGravity
        physicsBody.allowsRotation = scPhysicsBody.canRotate
        physicsBody.density = CGFloat(scPhysicsBody.density)
        physicsBody.friction = CGFloat(scPhysicsBody.friction)
        physicsBody.restitution = CGFloat(scPhysicsBody.restitution)
        physicsBody.linearDamping = CGFloat(scPhysicsBody.linearDamping)
        physicsBody.angularDamping = CGFloat(scPhysicsBody.angularDamping)
        
        skSprite.physicsBody = physicsBody
    }
    
    func instantiate(_ reference: ReferenceVariable, in ocScene: OCScene) -> SKSpriteNode? {
        let request = NSFetchRequest<SCSprite>(entityName: SCSprite.entityName)
        request.predicate = NSPredicate(format: "id == %@", reference.sourceId)
        
        guard let scSprite = self.connector.fetchEntities(request)?.first else {
            debugPrint("ERROR: couldn't fetch SCSprite from ReferenceVariable")
            return nil
        }
        
        guard let graphic = self.graphics[scSprite.graphic.id] else {
            debugPrint("ERROR: couldn't retrieve graphic for SCSprite from ReferenceVariable")
            return nil
        }
        
        let skSprite = SKSpriteNode(texture: graphic.frames.first!)
        skSprite.position = CGPoint(x: reference.position.x * ocScene.size.width,
                                    y: reference.position.y * ocScene.size.height)
        skSprite.setScale(CGFloat(reference.scale))
        skSprite.zRotation = CGFloat(reference.rotation)
        
        self.instantiate(scSprite.physicsBody, in: skSprite)
        
        return skSprite
    }
    
    
}
