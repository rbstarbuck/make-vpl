//
//  SCLayer+CoreDataClass.swift
//  Make
//
//  Created by Richmond Starbuck on 12/20/16.
//
//

import UIKit
import CoreData


public class SCLayer: NSManagedObject {
    public static let entityName = "Layer"

    
    public var index: Int {
        get {
            return CoreDataHelper.getter("index", in: self)!
        }
        set {
            CoreDataHelper.setter("index", value: newValue, in: self) {
                self.imageView_?.layer.zPosition = CGFloat(self.index)
            }
        }
    }
    
    public var image: UIImage {
        get {
            return CoreDataHelper.getter("image", in: self)!
        }
        set {
            CoreDataHelper.setter("image", value: newValue, in: self) {
                self.imageView_?.image = newValue
            }
        }
    }
    
    @NSManaged public var name: String
    @NSManaged public var frame: SCFrame
    
    public var world: SCWorld {
        get {
            return self.frame.world
        }
    }
    
    private weak var imageView_: UIImageView?
    public var imageView: UIImageView {
        get {
            var view = self.imageView_
            if view == nil {
                view = UIImageView(image: self.image)
                view!.image = self.image
                view!.layer.zPosition = CGFloat(self.index)
                self.imageView_ = view
            }
            return view!
        }
    }
    
    
    override public func awakeFromInsert() {
        self.image = UIImage()
    }
    
    public func move(to newIndex: Int) {
        let safeIndex = (newIndex < 0 ? 0 : (newIndex >= self.frame.layers.count ? self.frame.layers.count - 1 : newIndex))
        
        var from, to, increment: Int!
        if safeIndex < self.index {
            from = safeIndex
            to = self.index - 1
            increment = 1
        }
        else {
            from = self.index + 1
            to = safeIndex
            increment = -1
        }
        
        for layer in self.frame.layers {
            if layer.index >= from && layer.index <= to {
                layer.index += increment
            }
        }
        self.index = safeIndex
        self.world.connector.saveContext()
    }
    
    public func moveUp() {
        self.move(to: self.index + 1)
    }
    
    public func moveDown() {
        self.move(to: self.index - 1)
    }
    
    @discardableResult
    public func delete() -> Bool {
        if self.frame.layers.count < 2 {
            
        }
        self.world.connector.context.delete(self)
        return self.world.connector.saveContext()
    }
    
}
