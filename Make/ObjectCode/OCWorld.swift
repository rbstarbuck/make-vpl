//
//  OCWorld.swift
//  Make
//
//  Created by Richmond Starbuck on 1/31/17.
//
//

import UIKit
import CoreData


public class OCWorld {
    
    public var connector: SCConnector
    public var initialScene: String
    
    public var activeScene: OCScene!
    
    public var graphics = [String: OCGraphic]()
    public var variables = Variables()
    
    public var viewSize: CGSize
    
    
    public init(from scWorld: SCWorld, viewSize: CGSize) {
        self.connector = scWorld.connector
        self.initialScene = scWorld.initialScene
        self.viewSize = viewSize
        
        let graphicRequest: NSFetchRequest<SCGraphic> = SCGraphic.fetchRequest()
        graphicRequest.predicate = NSPredicate(format: "world = %@", scWorld)
        
        if let graphics = self.connector.fetchEntities(graphicRequest) {
            self.graphics = [String: OCGraphic](minimumCapacity: graphics.count)
            for graphic in graphics {
                self.graphics[graphic.id] = OCGraphic(from: graphic)
            }
        }
        
        self.setScene(id: scWorld.initialScene)
    }
    
    
    public func setScene(id: String) {
        let sceneRequest: NSFetchRequest<SCScene> = SCScene.fetchRequest()
        sceneRequest.predicate = NSPredicate(format: "id = %@", id)
        
        if let scScene = self.connector.fetchEntities(sceneRequest)?.first {
            self.activeScene = OCScene(from: scScene, in: self)
        }
    }
    
}
