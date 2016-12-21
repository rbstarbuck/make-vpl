//
//  Observable.swift
//  Make
//
//  Created by Richmond Starbuck on 12/20/16.
//
//

import Foundation


class Observable<T>: NSCoding {
    var listeners = WeakSet<(T, T) -> Void>()
    
    private var value: T
    
    init(_ initialValue: T) {
        value = initialValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        value = aDecoder.decodeObject(forKey: "value") as! T
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(value, forKey: "value")
    }
    
    func set(newValue: T) {
        let oldValue = value
        value = newValue
        for listener in listeners {
            listener(newValue, oldValue)
        }
    }
    
    func get() -> T {
        return value
    }
}
