//
//  SCPhysicsBodyShape.swift
//  Make
//
//  Created by Richmond Starbuck on 1/18/17.
//
//

import UIKit


@objc(SCPhysicsBodyShape)
public protocol SCPhysicsBodyShape: NSCoding {
    
    init()
    
}

public class SCPhysicsBodyShapeRectangle: NSObject, SCPhysicsBodyShape {

    public required override init() {
        super.init()
    }
    
    public required init(coder aDecoder: NSCoder) {
        
    }
    
    public func encode(with aCoder: NSCoder) {
        
    }
}
