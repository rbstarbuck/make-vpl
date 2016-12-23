//
//  FrameEditorController.swift
//  Make
//
//  Created by Richmond Starbuck on 12/21/16.
//
//

import UIKit
import CoreData


class FrameEditorController: EntityListener {
    
    var frame: SCFrame? {
        didSet {
            oldValue?.layerObserver.removeListener(self)
            frame?.layerObserver.addListener(self)
        }
    }
    
    func willChangeEntity(_ key: String) {
        if key == frame?.layerObserver.key {
            
        }
    }
    
    func onChangeEntity(_ key: String, entity: NSManagedObject, type: NSFetchedResultsChangeType,
                        oldIndex: IndexPath?, newIndex: IndexPath?) {
        if key == frame?.layerObserver.key {
            switch type {
            case .delete: break
            case .insert: break
            case .move: break
            case .update: break
            }
        }
    }
    
    func didChangeEntity(_ key: String) {
        if key == frame?.layerObserver.key {
            
        }
    }
}
