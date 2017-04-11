//
//  SCGravityEntity.swift
//  Make
//
//  Created by Richmond Starbuck on 4/10/17.
//
//

import Foundation


public protocol SCGravityEntity {
    
    var gravityMagnitude: Double { get set }
    var gravityDirection: GravityDirection { get set }
    
}
