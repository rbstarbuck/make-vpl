//
//  ObservableEntity.swift
//  Make
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
    
    public var sectionTitleDelegate: SectionTitleDelegate?
    
    private var isObserving = false
    private var listeners = WeakSet<EntityListener>()
    private var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    
    
    public init(key: String, entity: String, context: NSManagedObjectContext) {
        self.key = key
        self.entityName = entity
        self.managedObjectContext = context
    }
    
    public func startObserving() {
        isObserving = true
        if listeners.count > 0 {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = sortDescriptors
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: managedObjectContext,
                                                                  sectionNameKeyPath: sectionNameKeyPath,
                                                                  cacheName: nil)
            fetchedResultsController!.delegate = self
            do {
                try fetchedResultsController?.performFetch()
            }
            catch let error as NSError {
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }
    
    public func stopObserving() {
        isObserving = false
        fetchedResultsController?.delegate = nil
    }
    
    public func addListener(_ listener: EntityListener) {
        listeners.insert(listener)
        if listeners.count == 1 && isObserving {
            startObserving()
        }
    }
    
    public func removeListener(_ listener: EntityListener) {
        if listeners.remove(listener) && listeners.count == 0 {
            fetchedResultsController?.delegate = nil
        }
    }
    
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        for listener in listeners {
            listener.willChangeEntity(key)
        }
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any,
                           at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        for listener in listeners {
            listener.onChangeEntity(key, entity: anObject as! NSManagedObject,
                                    type: type, oldIndex: indexPath, newIndex: newIndexPath)
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
            listener.didChangeEntity(key)
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
    func sectionTitleForSection(_ sectionName: String) -> String?
}

