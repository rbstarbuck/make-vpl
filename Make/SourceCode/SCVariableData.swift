//
//  SCVariableData.swift
//  Make
//
//  Created by Richmond Starbuck on 1/31/17.
//
//

import Foundation


@objc
public enum VariableType: Int {
    case number, string, boolean
}


@objc
public protocol SCVariableData: NSCoding {
    
    var type: VariableType { get }
    
}

