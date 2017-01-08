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
                for imageView in self.imageViews {
                    imageView.layer.zPosition = CGFloat(self.index)
                }
            }
        }
    }
    
    public var image: UIImage {
        get {
            if let image: UIImage = CoreDataHelper.getter("image", in: self) {
                return image
            }
            let image = UIImage()
            self.image = image
            return image
        }
        set {
            CoreDataHelper.setter("image", value: newValue, in: self) {
                for imageView in self.imageViews {
                    imageView.image = newValue
                }
                self.frame.onLayerImageChange()
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
    
    private var imageViews = WeakSet<UIImageView>()
    
    public func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = self.image
        self.imageViews.insert(imageView)
        return imageView
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
        
        self.frame.onLayerImageChange()
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
