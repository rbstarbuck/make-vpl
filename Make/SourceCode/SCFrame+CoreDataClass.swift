//
//  SCFrame+CoreDataClass.swift
//  Make
//
//  Created by Richmond Starbuck on 12/20/16.
//
//

import UIKit
import CoreData


public class SCFrame: NSManagedObject {
    public static let entityName = "Frame"
    public static let layerObserverKey = "Frame->>Layer"
    public static let selectedLayerObserverKey = "selectedLayer"
    
    
    @NSManaged public var index: Int
    @NSManaged public var layers: Set<SCLayer>
    @NSManaged public var graphic: SCGraphic

    
    public var world: SCWorld {
        get {
            return self.graphic.world
        }
    }
    
    public var sortedLayers: [SCLayer] {
        get {
            let sorted = self.layers.sorted(by: {(lhs: SCLayer, rhs: SCLayer) -> Bool in
                return lhs.index < rhs.index
            })
            return sorted
        }
    }
    
    public lazy var layerObserver: ObservableEntity = {
        let observer = ObservableEntity(key: SCFrame.layerObserverKey,
                                        entity: SCLayer.entityName,
                                        context: self.world.connector.context)
        observer.predicate = NSPredicate(format: "frame == %@", self)
        observer.sortDescriptors.append(NSSortDescriptor(key: "index", ascending: true))
        observer.startObserving()
        return observer
    }()
    
    public lazy var selectedLayer: Observable<SCLayer> = {
        return Observable<SCLayer>(key: SCFrame.selectedLayerObserverKey,
                                   initialValue: self.sortedLayers.first!)
    }()
    
    
    override public func awakeFromInsert() {
        self.layers = Set<SCLayer>()
    }
    
    @discardableResult
    public func createLayer() -> SCLayer {
        let max = self.layers.map({$0.index}).max()
        let index = (max == nil ? 0 : max! + 1)
        
        let layer: SCLayer = self.world.connector.createEntity(SCLayer.entityName)!
        layer.index = index
        layer.name = "\(SCConstants.LAYER_DISPLAY_TITLE) \(self.layers.count + 1)"
        self.addToLayers(layer)
        
        self.world.connector.saveContext()
        return layer
    }
    
    public func copyLayers(from other: SCFrame) {
        for otherLayer in other.sortedLayers {
            let layer = self.createLayer()
            layer.image = otherLayer.image
            layer.name = otherLayer.name
        }
        self.world.connector.saveContext()
    }
    
    public func copyLayers(to other: SCFrame) {
        other.copyLayers(from: self)
    }
    
    public func move(to newIndex: Int) {
        let safeIndex = (newIndex < 0 ? 0 : (newIndex >= self.graphic.frames.count ?  self.graphic.frames.count - 1 : newIndex))
        
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
        
        for frame in self.graphic.frames {
            if frame.index >= from && frame.index <= to {
                frame.index += increment
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
        if self.graphic.frames.count < 2 {
            return false
        }
        self.world.connector.context.delete(self)
        return self.world.connector.saveContext()
    }
    
}
