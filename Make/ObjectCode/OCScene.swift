//
//  OCScene.swift
//  Make
//
//  Created by Richmond Starbuck on 1/29/17.
//
//

import UIKit
import SpriteKit


public class OCScene: SKScene {
    
    public var world: OCWorld!
    
    public var variables = Variables()
    
    public var gravityMagnitude = 9.8
    public var gravityDirection = GravityDirection.down
    
    
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

    public override init() {
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.world = aDecoder.decodeObject(forKey: "world") as! OCWorld
        self.gravityMagnitude = aDecoder.decodeDouble(forKey: "gravityMagnitude")
        let rawDirection = aDecoder.decodeInt32(forKey: "gravityDirection")
        self.gravityDirection = GravityDirection(rawValue: rawDirection)!
        
        
        super.init(coder: aDecoder)
    }
    
    public override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        
        aCoder.encode(self.world, forKey: "world")
        aCoder.encode(self.gravityMagnitude, forKey: "gravityMagnitude")
        aCoder.encode(self.gravityDirection.rawValue, forKey: "gravityDirection")
    }
    
}
