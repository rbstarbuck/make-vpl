//
//  ObservableEntity.swift
//
//  Created by Richmond Starbuck on 12/21/16.
//
//

import Foundation
import CoreData


public class ObservableEntity: NSObject, NSFetchedResultsControllerDelegate {
    
    public let key: String
    public var managedObjectContext: NSManagedObjectContext
    
    public var entityName: String
    public var predicate: NSPredicate?
    public var sortDescriptors = [NSSortDescriptor]()
    public var sectionNameKeyPath: String?
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    
    public var sectionTitleDelegate: SectionTitleDelegate?
    
    private var isObserving = false
    private var listeners = WeakSet<EntityListener>()
    
    
    // MARK: - Initialization
    
    public init(key: String, entity: String, context: NSManagedObjectContext) {
        self.key = key
        self.entityName = entity
        self.managedObjectContext = context
    }
    
    
    // MARK: - Listener handling
    
    public func startObserving() {
        isObserving = true
        if listeners.count > 0 {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            fetchRequest.predicate = self.predicate
            fetchRequest.sortDescriptors = self.sortDescriptors
            
            self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                       managedObjectContext: self.managedObjectContext,
                                                                       sectionNameKeyPath: self.sectionNameKeyPath,
                                                                       cacheName: nil)
            self.fetchedResultsController!.delegate = self
            do {
                try self.fetchedResultsController!.performFetch()
            }
            catch let error as NSError {
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }
    
    public func stopObserving() {
        self.isObserving = false
        self.fetchedResultsController?.delegate = nil
    }
    
    public func addListener(_ listener: EntityListener, populate: Bool = false) {
        self.listeners.insert(listener)
        if self.listeners.count == 1 && self.isObserving {
            self.startObserving()
        }
        if populate {
            self.populateListener(listener)
        }
    }
    
    public func removeListener(_ listener: EntityListener, depopulate: Bool = false) {
        if self.listeners.remove(listener) && self.listeners.count == 0 {
            self.fetchedResultsController?.delegate = nil
        }
        if depopulate {
            self.depopulateListener(listener)
        }
    }
    
    public func containsListener(_ listener: EntityListener) -> Bool {
        return self.listeners.contains(where: {$0 === listener})
    }
    
    public func populateListener(_ listener: EntityListener) {
        if let fetchedObjects = self.fetchedResultsController?.fetchedObjects {
            listener.willChangeEntity(self.key)
            for fetchedObject in fetchedObjects {
                let entity = fetchedObject as! NSManagedObject
                let indexPath = self.fetchedResultsController!.indexPath(forObject: fetchedObject)
                listener.onChangeEntity(self.key, entity: entity, type: .insert, oldIndex: nil, newIndex: indexPath)
            }
            listener.didChangeEntity(self.key)
        }
    }
    
    public func depopulateListener(_ listener: EntityListener) {
        if let fetchedObjects = self.fetchedResultsController?.fetchedObjects {
            listener.willChangeEntity(self.key)
            for fetchedObject in fetchedObjects {
                let entity = fetchedObject as! NSManagedObject
                let indexPath = self.fetchedResultsController!.indexPath(forObject: fetchedObject)
                listener.onChangeEntity(self.key, entity: entity, type: .delete, oldIndex: indexPath, newIndex: nil)
            }
            listener.didChangeEntity(self.key)
        }
    }
    
    
    // MARK: - NSFetchedResultsControllerDelegate methods
    
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        for listener in self.listeners {
            listener.willChangeEntity(self.key)
        }
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any,
                           at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        // ignore .update call when .move will be used
        if type == .update && indexPath != newIndexPath {
            return
        }
        
        for listener in self.listeners {
            listener.onChangeEntity(self.key, entity: anObject as! NSManagedObject,
                                    type: type, oldIndex: indexPath, newIndex: newIndexPath)
        }
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                           sectionIndexTitleForSectionName sectionName: String) -> String? {
        return (self.sectionTitleDelegate == nil ? sectionName : self.sectionTitleDelegate!.sectionTitle(for: sectionName))
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                           didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int,
                           for type: NSFetchedResultsChangeType) {
        for listener in self.listeners {
            listener.onChangeSectionInfo(self.key, info: sectionInfo, at: sectionIndex, type: type)
        }
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        for listener in self.listeners {
            listener.didChangeEntity(self.key)
        }
    }
}


public protocol EntityListener: class {
    func willChangeEntity(_ key: String)
    
    func onChangeEntity(_ key: String, entity: NSManagedObject,
                        type: NSFetchedResultsChangeType, oldIndex: IndexPath?, newIndex: IndexPath?)
    
    func onChangeSectionInfo(_ key: String, info: NSFetchedResultsSectionInfo,
                             at index: Int, type: NSFetchedResultsChangeType)
    
    func didChangeEntity(_ key: String)
}

public extension EntityListener {
    func willChangeEntity(_ key: String) {}
    
    func onChangeEntity(_ key: String, entity: NSManagedObject,
                        type: NSFetchedResultsChangeType, oldIndex: IndexPath?, newIndex: IndexPath?) {}
    
    func onChangeSectionInfo(_ key: String, info: NSFetchedResultsSectionInfo,
                             at index: Int, type: NSFetchedResultsChangeType) {}
    
    func didChangeEntity(_ key: String) {}
}


public protocol SectionTitleDelegate: class {
    func sectionTitle(for sectionName: String) -> String?
}

