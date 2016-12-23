//
//  SCFrame+CoreDataClass.swift
//  Make
//
//  Created by Richmond Starbuck on 12/20/16.
//
//

import Foundation
import CoreData


public class SCFrame: NSManagedObject {
    public class func entityName() -> String {
        return "Frame"
    }
    
    static public let layerObserverKey = "Frame->>layers"
    
    
    @NSManaged public var graphic: SCGraphic
    @NSManaged public var layers: Set<SCLayer>
    
    
    public var world: SCWorld {
        get {
            return self.graphic.world
        }
    }
    
    public var connector: SCConnector {
        get {
            return self.world.connector
        }
    }
    
    public lazy var layerObserver: ObservableEntity = {
        let observer = ObservableEntity(key: SCFrame.layerObserverKey, entity: SCLayer.entityName(), context: self.connector.context)
        observer.predicate = NSPredicate(format: "frame == %@", self)
        observer.sortDescriptors.append(NSSortDescriptor(key: "index", ascending: true))
        observer.startObserving()
        return observer
    }()
    
    
    @discardableResult
    public func createLayer() -> SCLayer? {
        if let layer: SCLayer = self.connector.createEntity(SCLayer.entityName()) {
            if let max = self.layers.map({$0.index}).max() {
                layer.index = max + 1
            }
            self.addToLayers(layer)
            return layer
        }
        return nil
    }
}
