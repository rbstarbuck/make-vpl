//
//  Weak.swift
//  PlanIt
//
//  Created by Richmond Starbuck on 10/14/16.
//  Copyright © 2016 OneTwo Productions. All rights reserved.
//

import Foundation

public struct Weak<T>: Hashable {
    private weak var value_: AnyObject?
    public var value: T? {
        get {
            return self.value_ as? T
        }
        set {
            self.value_ = newValue as AnyObject
        }
    }
    
    public var hashValue: Int {
        get {
            return ObjectIdentifier(self.value_ as AnyObject).hashValue
        }
    }
    
    public init (value: T) {
        self.value_ = value as AnyObject
    }
}

public func == <T>(lhs: Weak<T>, rhs: Weak<T>) -> Bool {
    return lhs.value as AnyObject === rhs.value as AnyObject
}
