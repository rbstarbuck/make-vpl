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
    public class func entityName() -> String {
        return "Layer"
    }
    
    
    @NSManaged public var frame: SCFrame
    @NSManaged public var name: String
    
    
    public var index: Int {
        get {
            return coreDataGetter("index", in: self)!
        }
        set {
            coreDataSetter("index", value: newValue, in: self) {
                self.setImageViewZIndex()
            }
        }
    }
    
    public var image: UIImage {
        get {
            return coreDataGetter("image", in: self)!
        }
        set {
            coreDataSetter("image", value: newValue, in: self) {
                if self.imageView_ != nil {
                    self.imageView_?.image = newValue
                }
            }
        }
    }
    
    private var imageView_: UIImageView?
    public var imageView: UIImageView {
        get {
            if self.imageView_ == nil {
                self.imageView_ = UIImageView(image: self.image)
                self.setImageViewZIndex()
            }
            return self.imageView_!
        }
    }
    
    public func move(to newIndex: Int) {
        let safeIndex = (newIndex < 0 ? 0 : (newIndex >= self.frame.layers.count ? self.frame.layers.count - 1 : newIndex))
        let mod = (safeIndex < self.index ? 1 : -1)
        let from = min(safeIndex, self.index)
        let to = max(safeIndex, self.index)
        for layer in self.frame.layers {
            if layer.index >= from && layer.index <= to {
                layer.index += mod
            }
        }
        self.index = safeIndex
    }
    
    public func moveUp() {
        self.move(to: self.index + 1)
    }
    
    public func moveDown() {
        self.move(to: self.index - 1)
    }
    
    private func setImageViewZIndex() {
        if let imageView = self.imageView_ {
            imageView.layer.zPosition = CGFloat(self.index)
        }
    }
}
