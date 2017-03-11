//
//  SCGraphic+CoreDataClass.swift
//  Make
//
//  Created by Richmond Starbuck on 12/20/16.
//
//

import UIKit
import CoreData


public class SCGraphic: NSManagedObject {
    public static let entityName = "Graphic"
    public static let frameObserverKey = "Graphic->>Frame"
    public static let selectedFrameObserverKey = "selectedFrame"
    
    
    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var dateCreated: Date
    @NSManaged public var frames: Set<SCFrame>
    @NSManaged public var sprites: Set<SCSprite>?
    @NSManaged public var world: SCWorld
    
    
    public var sortedFrames: [SCFrame] {
        get {
            let sorted = self.frames.sorted(by: {$0.index < $1.index})
            return sorted
        }
    }
    
    public var firstFrame: SCFrame {
        get {
            return self.frames.first(where: {$0.index == 0})!
        }
    }
    
    public var lastFrame: SCFrame {
        get {
            let index = self.frames.count - 1
            return self.frames.first(where: {$0.index == index})!
        }
    }
    
    public lazy var frameObserver: ObservableEntity = {
        let observer = ObservableEntity(key: SCGraphic.frameObserverKey,
                                        entity: SCFrame.entityName,
                                        context: self.world.connector.context)
        observer.predicate = NSPredicate(format: "graphic == %@", self)
        observer.sortDescriptors.append(NSSortDescriptor(key: "index", ascending: true))
        observer.startObserving()
        return observer
    }()
    
    public lazy var selectedFrame: Observable<SCFrame> = {
        return Observable<SCFrame>(key: SCGraphic.selectedFrameObserverKey,
                                   initialValue: self.sortedFrames.first!)
    }()
    
    
    override public func awakeFromInsert() {
        self.id = UUID().uuidString
        self.dateCreated = Date()
    }
    
    @discardableResult
    public func createFrame() -> SCFrame {
        let frame: SCFrame = self.world.connector.createEntity(SCFrame.entityName)!
        frame.index = self.frames.count
        self.addToFrames(frame)
        
        frame.createLayer()
        
        self.world.connector.saveContext()
        return frame
    }
    
    @discardableResult
    public func delete() -> Bool {
        self.world.connector.context.delete(self)
        return self.world.connector.saveContext()
    }
    
    
    func makeGraphicFromFrames() -> [UIImage] {
        var frames = [UIImage]()
        frames.reserveCapacity(self.frames.count)
        
        for frame in self.sortedFrames {
            let image = frame.makeImageFromLayers()
            frames.append(image)
        }
        
        return frames
    }
}
