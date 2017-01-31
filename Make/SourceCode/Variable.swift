//
//  Variable.swift
//  Make
//
//  Created by Richmond Starbuck on 1/31/17.
//
//

import Foundation


@objc
public protocol Variable: class {
    
    func instantiate(in scene: OCScene)
    
}
