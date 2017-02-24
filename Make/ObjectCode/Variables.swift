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
    
    public var numbers = [String: NSNumber]()
    public var strings = [String: String]()
    public var booleans = [String: Bool]()
    
    
    public func insert(_ copy: Variables) {
        for (k, v) in copy.numbers {
            self.numbers[k] = v
        }
        
        for (k, v) in copy.strings {
            self.strings[k] = v
        }
        
        for (k, v) in copy.booleans {
            self.booleans[k] = v
        }
    }
    
}
