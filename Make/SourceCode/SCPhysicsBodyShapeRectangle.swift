//
//  SCPhysicsBodyShapeRectangle.swift
//  Make
//
//  Created by Richmond Starbuck on 3/20/17.
//
//

import UIKit
import SpriteKit


public class SCPhysicsBodyShapeRectangle: NSObject, SCPhysicsBodyShape {
    
    public let center: CGPoint
    public let size: CGSize
    
    public var shape: PhysicsShape {
        get {
            return .rectangle
        }
    }
    
    
    public convenience override init() {
        self.init(center: CGPoint(x: 0.5, y: 0.5), size: CGSize(width: 0.8, height: 0.8))
    }
    
    public init(center: CGPoint, size: CGSize) {
        self.center = center
        self.size = size
    }
    
    public required init(coder aDecoder: NSCoder) {
        self.center = aDecoder.decodeCGPoint(forKey: "center")
        self.size = aDecoder.decodeCGSize(forKey: "size")
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.center, forKey: "center")
        aCoder.encode(self.size, forKey: "size")
    }
    
    
    public func instantiate(for sprite: SKSpriteNode) -> SKPhysicsBody {
        let frameSize = CGSize(width: self.size.width * sprite.size.width, height: self.size.height * sprite.size.height)
        let frameCenter = CGPoint(x: self.center.x * sprite.size.width, y: self.center.y * sprite.size.height)
        return SKPhysicsBody(rectangleOf: frameSize, center: frameCenter)
    }
    
}
