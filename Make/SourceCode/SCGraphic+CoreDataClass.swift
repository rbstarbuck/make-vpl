//
//  SCGraphic+CoreDataClass.swift
//  Make
//
//  Created by Richmond Starbuck on 12/20/16.
//
//

import Foundation
import CoreData


public class SCGraphic: NSManagedObject {
    public static let entityName = "Graphic"
    public static let frameObserverKey = "Graphic->>Frame"
    public static let selectedFrameObserverKey = "selectedFrame"
    
    
    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var frames: Set<SCFrame>
    @NSManaged public var sprites: Set<SCSprite>?
    @NSManaged public var world: SCWorld
    
    
    public var sortedFrames: [SCFrame] {
        get {
            let sorted = self.frames.sorted(by: {(lhs: SCFrame, rhs: SCFrame) -> Bool in
                return lhs.index < rhs.index
            })
            return sorted
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
        self.frames = Set<SCFrame>()
        self.sprites = Set<SCSprite>()
    }
    
    @discardableResult
    public func createFrame() -> SCFrame {
        let max = self.frames.map({$0.index}).max()
        let index = (max == nil ? 0 : max! + 1)
        
        let frame: SCFrame = self.world.connector.createEntity(SCFrame.entityName)!
        frame.index = index
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
}
