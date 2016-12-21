//
//  WeakSet.swift
//  PlanIt
//
//  Created by Richmond Starbuck on 10/13/16.
//  Copyright © 2016 OneTwo Productions. All rights reserved.
//

import Foundation

public class WeakSet<T>: Sequence {
    
    // MARK: - Variables
    
    private var values = Set<Weak<T>>()
    
    
    // MARK: - Initialization
    
    public init() {}
    
    public init(elements: [T]) {
        for element in elements {
            self.insert(element)
        }
    }
    
    
    // MARK: - Set operations
    
    public var count: Int {
        get {
            return values.count
        }
    }
    
    public func insert(_ newElement: T) {
        let ref = Weak(value: newElement)
        self.values.insert(ref)
    }
    
    @discardableResult public func remove(_ element: T) -> Bool {
        let ref = Weak(value: element)
        return self.values.remove(ref) != nil
    }
    
    public func removeAll() {
        self.values.removeAll()
    }
    
    public func makeIterator() -> WeakSetIterator<T> {
        return WeakSetIterator<T>(weakSet: self, iterator: self.values.makeIterator())
    }
    
    
    // MARK: - Memory management
    
    public func reap() {
        var notNil = Set<Weak<T>>()
        for element in self.values {
            if element.value != nil {
                notNil.insert(element)
            }
        }
        self.values = notNil
    }
}

public class WeakSetIterator<T>: IteratorProtocol {
    
    // MARK: - Variables
    
    private var weakSet: WeakSet<T>
    private var iterator: SetIterator<Weak<T>>
    private var hasNilReference = false
    
    
    // MARK: - Initialization
    
    public init(weakSet: WeakSet<T>, iterator: SetIterator<Weak<T>>) {
        self.weakSet = weakSet
        self.iterator = iterator
    }
    
    
    // MARK: - IteratorProtocol methods
    
    public func next() -> T? {
        let next = self.iterator.next()
        if next == nil {
            if self.hasNilReference {
                self.weakSet.reap()
            }
            return nil
        }
        else if let value = next!.value {
            return value
        }
        else {
            self.hasNilReference = true
            return self.next()
        }
    }
}
