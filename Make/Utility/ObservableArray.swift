//
//  ObservableArray.swift
//  Make
//
//  Created by Richmond Starbuck on 12/20/16.
//
//

import Foundation


class ObservableArray<T>: Sequence, NSCoding {
    var listeners = WeakSet<(ArrayProperty, Any) -> Void>()
    
    private var values: NSMutableArray
    
    
    init() {
        values = NSMutableArray()
    }
    
    init(_ array: [T]) {
        values = NSMutableArray(array: array)
    }
    
    
    // MARK: - NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        if let arr = aDecoder.decodeObject(forKey: "values") as? NSMutableArray {
            values = arr
        }
        else {
            values = NSMutableArray()
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(values, forKey: "values")
    }
    
    
    // MARK: - Accessors
    
    var first: T? {
        get {
            return values.firstObject as? T
        }
    }
    
    var last: T? {
        get {
            return values.lastObject as? T
        }
    }

    subscript (_ index: Int) -> T? {
        return indexInRange(index) ? values[index] as? T : nil
    }
    
    func count() -> Int {
        return values.count
    }
    
    func makeIterator() -> NSFastEnumerationIterator {
        return values.makeIterator()
    }
    
    
    // MARK: - Mutators
    
    func append(_ element: T) {
        values.add(element)
        inform(.Insert, OnInsert(value: element, at: values.count - 1))
    }
    
    func prepend(_ element: T) {
        values.insert(element, at: 0)
        inform(.Insert, OnInsert(value: element, at: 0))
    }
    
    func insert(_ element: T, at atIndex: Int) {
        values.insert(element, at: atIndex)
        inform(.Insert, OnInsert(value: element, at: atIndex))
    }
    
    @discardableResult func removeFirst() -> T? {
        var removed: T? = nil
        if values.count > 0 {
            removed = values.firstObject as? T
            values.removeObject(at: 0)
            inform(.Remove, OnRemove(value: removed, at: 0))
        }
        return removed
    }
    
    @discardableResult func removeLast() -> T? {
        var removed: T? = nil
        if values.count > 0 {
            removed = values.lastObject as? T
            values.removeLastObject()
            inform(.Remove, OnRemove(value: removed, at: values.count))
        }
        return removed
    }
    
    @discardableResult func remove(at index: Int) -> T? {
        var removed: T? = nil
        if indexInRange(index) {
            removed = values[index] as? T
            values.removeObject(at: index)
            inform(.Remove, OnRemove(value: removed, at: index))
        }
        return removed
    }
    
    func move(from fromIndex: Int, to toIndex: Int) {
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


enum ArrayProperty {
    case Set, Insert, Remove, Move
}


struct OnSet {
    var oldValue: NSMutableArray
    var newValue: NSMutableArray
    
    init(oldValue: NSMutableArray, newValue: NSMutableArray) {
        self.oldValue = oldValue
        self.newValue = newValue
    }
}


struct OnInsert<T> {
    var value: T
    var at: Int
    
    init(value: T, at: Int) {
        self.value = value
        self.at = at
    }
}


struct OnRemove<T> {
    var value: T
    var at: Int
    
    init(value: T, at: Int) {
        self.value = value
        self.at = at
    }
}


struct OnMove<T> {
    var value: T
    var from: Int
    var to: Int
    
    init(value: T, from: Int, to: Int) {
        self.value = value
        self.from = from
        self.to = to
    }
}
