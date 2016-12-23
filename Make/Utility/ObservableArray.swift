//
//  ObservableArray.swift
//  Make
//
//  Created by Richmond Starbuck on 12/20/16.
//
//

import Foundation


public class ObservableArray<T>: Sequence, NSCoding {
    public var listeners = WeakSet<(ArrayProperty, Any) -> Void>()
    
    private var values: NSMutableArray
    
    public var asArray: [T] {
        get {
            return NSArray(array:values) as! Array<T>
        }
    }
    
    
    public init() {
        values = NSMutableArray()
    }
    
    public init(_ array: [T]) {
        values = NSMutableArray(array: array)
    }
    
    
    // MARK: - NSCoding
    
    public required init?(coder aDecoder: NSCoder) {
        if let arr = aDecoder.decodeObject(forKey: "values") as? NSMutableArray {
            values = arr
        }
        else {
            values = NSMutableArray()
        }
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(values, forKey: "values")
    }
    
    
    // MARK: - Accessors
    
    public var first: T? {
        get {
            return values.firstObject as? T
        }
    }
    
    public var last: T? {
        get {
            return values.lastObject as? T
        }
    }

    public subscript (_ index: Int) -> T? {
        return indexInRange(index) ? values[index] as? T : nil
    }
    
    public func count() -> Int {
        return values.count
    }
    
    public func makeIterator() -> NSFastEnumerationIterator {
        return values.makeIterator()
    }
    
    
    // MARK: - Mutators
    
    public func append(_ element: T) {
        values.add(element)
        inform(.Insert, OnInsert(value: element, at: values.count - 1))
    }
    
    public func prepend(_ element: T) {
        values.insert(element, at: 0)
        inform(.Insert, OnInsert(value: element, at: 0))
    }
    
    public func insert(_ element: T, at atIndex: Int) {
        values.insert(element, at: atIndex)
        inform(.Insert, OnInsert(value: element, at: atIndex))
    }
    
    @discardableResult
    public func removeFirst() -> T? {
        var removed: T? = nil
        if values.count > 0 {
            removed = values.firstObject as? T
            values.removeObject(at: 0)
            inform(.Remove, OnRemove(value: removed, at: 0))
        }
        return removed
    }
    
    @discardableResult
    public func removeLast() -> T? {
        var removed: T? = nil
        if values.count > 0 {
            removed = values.lastObject as? T
            values.removeLastObject()
            inform(.Remove, OnRemove(value: removed, at: values.count))
        }
        return removed
    }
    
    @discardableResult
    public func remove(at index: Int) -> T? {
        var removed: T? = nil
        if indexInRange(index) {
            removed = values[index] as? T
            values.removeObject(at: index)
            inform(.Remove, OnRemove(value: removed, at: index))
        }
        return removed
    }
    
    public func move(from fromIndex: Int, to toIndex: Int) {
        if indexInRange(fromIndex) && indexInRange(toIndex) && fromIndex != toIndex {
            let from = values[fromIndex]
            let to = values[toIndex]
            values.replaceObject(at: fromIndex, with: to)
            values.replaceObject(at: toIndex, with: from)
            inform(.Move, OnMove(value: from, from: fromIndex, to: toIndex))
        }
    }
    
    
    // MARK: - Helpers
    
    private func inform(_ property: ArrayProperty, _ data: Any) {
        for listener in listeners {
            listener(property, data)
        }
    }
    
    private func indexInRange(_ index: Int) -> Bool {
        return index >= 0 && index < values.count
    }
}


public enum ArrayProperty {
    case Set, Insert, Remove, Move
}


public struct OnSet {
    public var oldValue: NSMutableArray
    public var newValue: NSMutableArray
    
    public init(oldValue: NSMutableArray, newValue: NSMutableArray) {
        self.oldValue = oldValue
        self.newValue = newValue
    }
}


public struct OnInsert<T> {
    public var value: T
    public var at: Int
    
    public init(value: T, at: Int) {
        self.value = value
        self.at = at
    }
}


public struct OnRemove<T> {
    public var value: T
    public var at: Int
    
    public init(value: T, at: Int) {
        self.value = value
        self.at = at
    }
}


public struct OnMove<T> {
    public var value: T
    public var from: Int
    public var to: Int
    
    public init(value: T, from: Int, to: Int) {
        self.value = value
        self.from = from
        self.to = to
    }
}
