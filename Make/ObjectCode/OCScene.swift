//
//  OCScene.swift
//  Make
//
//  Created by Richmond Starbuck on 1/29/17.
//
//

import UIKit
import CoreData
import SpriteKit


public class OCScene: SKScene {
    
    public var world: OCWorld
    
    public var variables: Variables
    
    public var gravityMagnitude: Double {
        didSet {
            self.setGravity()
        }
    }
    
    public var gravityDirection: GravityDirection {
        didSet {
            self.setGravity()
        }
    }
    
    
    public var gravityVector: CGVector {
        get {
            let magnitude = self.gravityMagnitude
            switch self.gravityDirection {
            case .down:     return CGVector(dx: 0,          dy: -magnitude)
            case .up:       return CGVector(dx: 0,          dy: magnitude)
            case .left:     return CGVector(dx: -magnitude, dy: 0)
            case .right:    return CGVector(dx: magnitude,  dy: 0)
            }
        }
    }
    
    public var connector: SCConnector {
        get {
            return self.world.connector
        }
    }
    
    public init(from scScene: SCScene, in ocWorld: OCWorld) {
        self.world = ocWorld
        self.variables = Variables(parent: ocWorld.variables)
        self.gravityMagnitude = scScene.gravityMagnitude
        self.gravityDirection = scScene.gravityDirection
        
        super.init(size: CGSize(width: 500, height: 300))
        
//        for scVariable in scScene.variables {
//            var ocVariable: OCVariable!
//            
//            switch scVariable.data.type {
//            case .reference:
//                ocVariable = OCSprite(from: scVariable, in: self)
//                self.addChild(ocVariable as! OCSprite)
//                break
//                
//            case .number: break
//            case .string: break
//            case .boolean: break
//            }
//            
//            self.variables.insert(ocVariable)
//        }
        
        
        for reference in scScene.references {
            let sprite = OCSprite(from: reference, in: self)
            self.addChild(sprite)
        }
        
        self.setGravity()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.world = aDecoder.decodeObject(forKey: "world") as! OCWorld
        self.variables = aDecoder.decodeObject(forKey: "variables") as! Variables
        self.gravityMagnitude = aDecoder.decodeDouble(forKey: "gravityMagnitude")
        let rawDirection = aDecoder.decodeInt32(forKey: "gravityDirection")
        self.gravityDirection = GravityDirection(rawValue: rawDirection)!
        
        super.init(coder: aDecoder)
    }
    
    public override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        
        aCoder.encode(self.world, forKey: "world")
        aCoder.encode(self.variables, forKey: "variables")
        aCoder.encode(self.gravityMagnitude, forKey: "gravityMagnitude")
        aCoder.encode(self.gravityDirection.rawValue, forKey: "gravityDirection")
    }
    
    
    public func setGravity() {
        self.physicsWorld.gravity = self.gravityVector
    }
    
}
