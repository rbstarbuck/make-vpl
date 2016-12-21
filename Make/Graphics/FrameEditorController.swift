//
//  FrameEditorController.swift
//  Make
//
//  Created by Richmond Starbuck on 12/21/16.
//
//

import UIKit
import CoreData


class FrameEditorController: RelationshipListener {
    
    var frame: SCFrame? {
        didSet {
            oldValue?.layerObserver.removeListener(self)
            frame?.layerObserver.addListener(self)
        }
    }
    
    func willChangeRelationship(_ key: String) {
        <#code#>
    }
    
    func onChangeRelationship(_ key: String, entity: NSManagedObject, type: NSFetchedResultsChangeType, oldIndex: Int?, newIndex: Int?) {
        <#code#>
    }
    
    func didChangeRelationship(_ key: String) {
        <#code#>
    }
}
