//
//  Variables.swift
//  Make
//
//  Created by Richmond Starbuck on 2/24/17.
//
//

import Foundation
import SpriteKit


public class Variables {
    
    public var parent: Variables?
    public var variables = [String: OCVariable]()
    
    
    public init() { }
    
    public init(parent: Variables) {
        self.parent = parent
    }
    
    
    public func insert(_ ocVariable: OCVariable) {
        self.variables[ocVariable.id] = ocVariable
    }
    
    public subscript(_ id: String) -> OCVariable? {
        var variable = self.variables[id]
        if variable == nil {
            variable = self.parent?[id]
        }
        return variable
    }
    
}
