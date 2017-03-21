//
//  SCPhysicsBodyShapeCircle.swift
//  Make
//
//  Created by Richmond Starbuck on 3/20/17.
//
//

import UIKit
import SpriteKit


public class SCPhysicsBodyShapeCircle: NSObject, SCPhysicsBodyShape {
    
    public let center: CGPoint
    public let radius: Double
    
    public var type: PhysicsShape {
        get {
            return .circle
        }
    }
    
    
    public override convenience init() {
        self.init(center: CGPoint(x: 0.5, y: 0.5), radius: 0.4)
    }
    
    public init(center: CGPoint, radius: Double) {
        self.center = center
        self.radius = radius
    }
    
    public required init(coder aDecoder: NSCoder) {
        self.center = aDecoder.decodeCGPoint(forKey: "center")
        self.radius = aDecoder.decodeDouble(forKey: "radius")
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.center, forKey: "center")
        aCoder.encode(self.radius, forKey: "radius")
    }
    
    
    public func instantiate(for sprite: SKSpriteNode) -> SKPhysicsBody {
        let frameRadius = CGFloat(self.radius) * sprite.size.height
        let frameCenter = CGPoint(x: self.center.x * sprite.size.width, y: self.center.y * sprite.size.height)
        return SKPhysicsBody(circleOfRadius: frameRadius, center: frameCenter)
    }
}
