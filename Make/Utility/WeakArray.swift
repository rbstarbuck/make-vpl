//
//  WeakArray.swift
//  Make
//
//  Created by Richmond Starbuck on 3/25/17.
//
//

import Foundation

public class WeakArray<T>: Sequence {
    
    private var values = [Weak<T>]()
    
    var count: Int {
        get {
            self.reap()
            return self.values.count
        }
    }
    
    
    public init() {}
    
    public init(elements: [T]) {
        for element in elements {
            self.append(element)
        }
    }
    
    
    public func append(_ newElement: T) {
        let ref = Weak(value: newElement)
        self.values.append(ref)
    }
    
    @discardableResult
    public func popLast() -> T? {
        var element: T?
        while self.values.count > 0 && element == nil {
            element = self.values.popLast()?.value
        }
        return element
    }
    
    public func removeAll() {
        self.values.removeAll()
    }
    
    public func indexOf(_ element: T) -> Int? {
        var index: Int?
        var notNil = Array<Weak<T>>()
        var currentIndex = 0
        for item in self.values {
            if let value = item.value {
                notNil.append(item)
                if value as AnyObject === element as AnyObject {
                    index = currentIndex
                }
                currentIndex += 1
            }
        }
        self.values = notNil
        return index
    }
    
    
    public func makeIterator() -> WeakArrayIterator<T> {
        return WeakArrayIterator<T>(weakArray: self, iterator: self.values.makeIterator())
    }
    
    
    public func reap() {
        var notNil = Array<Weak<T>>()
        for element in self.values {
            if element.value != nil {
                notNil.append(element)
            }
        }
        self.values = notNil
    }
    
}


public class WeakArrayIterator<T>: IteratorProtocol {
    
    // MARK: - Variables
    
    private var weakArray: WeakArray<T>
    private var iterator: IndexingIterator<Array<Weak<T>>>
    private var hasNilReference = false
    
    
    // MARK: - Initialization
    
    public init(weakArray: WeakArray<T>, iterator: IndexingIterator<Array<Weak<T>>>) {
        self.weakArray = weakArray
        self.iterator = iterator
    }
    
    
    // MARK: - IteratorProtocol methods
    
    public func next() -> T? {
        let next = self.iterator.next()
        if next == nil {
            if self.hasNilReference {
                self.weakArray.reap()
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
