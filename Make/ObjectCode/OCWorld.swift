//
//  OCWorld.swift
//  Make
//
//  Created by Richmond Starbuck on 1/31/17.
//
//

import Foundation
import CoreData


public class OCWorld {
    
    public var source: SCWorld
    
    public var graphics = [String: OCGraphic]()
    
    
    public init(from source: SCWorld) {
        self.source = source
        
        let request: NSFetchRequest<SCGraphic> = SCGraphic.fetchRequest()
        do {
            let graphics = try self.source.connector.context.fetch(request)
            for graphic in graphics {
                self.graphics[graphic.id] = OCGraphic(from: graphic)
            }
        }
        catch let error {
            debugPrint("ERROR: couldn't fetch graphics from world: \(error.localizedDescription)")
        }
    }
}
