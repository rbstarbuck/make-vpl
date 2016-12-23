//
//  Observable.swift
//  Make
//
//  Created by Richmond Starbuck on 12/20/16.
//
//

import Foundation


public class Observable<T>: NSCoding {
    public var listeners = WeakSet<(T, T) -> Void>()
    
    private var value: T
    
    public init(_ initialValue: T) {
        value = initialValue
    }
    
    public required init?(coder aDecoder: NSCoder) {
        value = aDecoder.decodeObject(forKey: "value") as! T
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(value, forKey: "value")
    }
    
    public func set(newValue: T) {
        let oldValue = value
        value = newValue
        for listener in listeners {
            listener(newValue, oldValue)
        }
    }
    
    public func get() -> T {
        return value
    }
}
