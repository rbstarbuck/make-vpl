//
//  Observable.swift
//  Make
//
//  Created by Richmond Starbuck on 12/20/16.
//
//

import Foundation


public class Observable<T>: NSCoding {
    private var listeners = WeakSet<PropertyListener>()
    
    public var key: String
    
    public var value: T? {
        didSet {
            for listener in listeners {
                listener.onPropertyChange(key: self.key, newValue: self.value, oldValue: oldValue)
            }
        }
    }
    
    public init(key: String, initialValue: T? = nil) {
        self.key = key
        self.value = initialValue
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.key = aDecoder.decodeObject(forKey: "key") as! String
        self.value = aDecoder.decodeObject(forKey: "value") as? T
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.key, forKey: "key")
        aCoder.encode(self.value, forKey: "value")
    }
    
    
    public func addListener(_ listener: PropertyListener, populate: Bool = false) {
        self.listeners.insert(listener)
        if populate {
            listener.onPropertyChange(key: self.key, newValue: self.value, oldValue: nil)
        }
    }
    
    @discardableResult
    public func removeListener(_ listener: PropertyListener, depopulate: Bool = false) -> Bool {
        if depopulate {
            listener.onPropertyChange(key: self.key, newValue: nil, oldValue: self.value)
        }
        return self.listeners.remove(listener)
    }
}


public protocol PropertyListener: class {
    
    func onPropertyChange(key: String, newValue: Any?, oldValue: Any?)
    
}

