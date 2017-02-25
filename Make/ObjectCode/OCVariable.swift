//
//  OCVariable.swift
//  Make
//
//  Created by Richmond Starbuck on 2/24/17.
//
//

import Foundation


public protocol OCVariable: NSCoding {
    
    var type: VariableType { get }
    
    var id: String { get }
    
}
