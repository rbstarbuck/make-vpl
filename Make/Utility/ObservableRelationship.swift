//
//  ObservableRelationship.swift
//  Make
//
//  Created by Richmond Starbuck on 12/21/16.
//
//

import Foundation
import CoreData


public class ObservableRelationship: NSObject, NSFetchedResultsControllerDelegate {
    
    public let key: String
    
    public var listeners = WeakSet<RelationshipListener>()
    public var sectionTitleDelegate: SectionTitleDelegate?
    
    private var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>
    
    
    public init(entity: NSManagedObject, relatedEntityName: String, inverseRelationship: String, context: NSManagedObjectContext,
                sectionNameKeyPath: String? = nil, sectionTitleDelegate: SectionTitleDelegate? = nil) {
        self.key = "\(relatedEntityName):\(inverseRelationship)"
        self.sectionTitleDelegate = sectionTitleDelegate
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: relatedEntityName)
        fetchRequest.predicate = NSPredicate(format: "\(inverseRelationship) == %@", entity)
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                   managedObjectContext: context,
                                                                   sectionNameKeyPath: sectionNameKeyPath,
                                                                   cacheName: nil)
        do {
            try self.fetchedResultsController.performFetch()
        }
        catch let error as NSError {
            print("ERROR: \(error.localizedDescription)")
        }
    }
    
    public func addListener(_ listener: RelationshipListener) {
        if listeners.count == 0 {
            fetchedResultsController.delegate = self
        }
        listeners.insert(listener)
    }
    
    public func removeListener(_ listener: RelationshipListener) {
        if listeners.remove(listener) && listeners.count == 0 {
            fetchedResultsController.delegate = nil
        }
    }
    
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        for listener in listeners {
            listener.willChangeRelationship(key)
        }
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any,
                           at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        for listener in listeners {
            listener.onChangeRelationship(key, entity: anObject as! NSManagedObject,
                                          type: type, oldIndex: indexPath?.row, newIndex: newIndexPath?.row)
        }
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                           sectionIndexTitleForSectionName sectionName: String) -> String? {
        return (sectionTitleDelegate == nil ? sectionName : sectionTitleDelegate!.sectionTitleForSection(sectionName))
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                           didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int,
                           for type: NSFetchedResultsChangeType) {
        for listener in listeners {
            listener.onChangeSectionInfo(key, info: sectionInfo, at: sectionIndex, type: type)
        }
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        for listener in listeners {
            listener.didChangeRelationship(key)
        }
    }
}


public protocol RelationshipListener: class {
    func willChangeRelationship(_ key: String)
    
    func onChangeRelationship(_ key: String, entity: NSManagedObject,
                              type: NSFetchedResultsChangeType, oldIndex: Int?, newIndex: Int?)
    
    func onChangeSectionInfo(_ key: String, info: NSFetchedResultsSectionInfo,
                             at index: Int, type: NSFetchedResultsChangeType)
    
    func didChangeRelationship(_ key: String)
}

public extension RelationshipListener {
    func willChangeRelationship(_ key: String) {}
    
    func onChangeRelationship(_ key: String, entity: NSManagedObject,
                              type: NSFetchedResultsChangeType, oldIndex: Int?, newIndex: Int?) {}
    
    func onChangeSectionInfo(_ key: String, info: NSFetchedResultsSectionInfo,
                             at index: Int, type: NSFetchedResultsChangeType) {}
    
    func didChangeRelationship(_ key: String) {}
}


public protocol SectionTitleDelegate: class {
    func sectionTitleForSection(_ sectionName: String) -> String?
}

