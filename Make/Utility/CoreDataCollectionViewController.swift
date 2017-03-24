//
//  CoreDataCollectionViewController.swift
//
//  Created by Richmond Starbuck on 12/31/16.
//
//

import UIKit
import CoreData


protocol CoreDataCollectionViewDelegate {
    
    var collectionView: UICollectionView { get }
    var cellIdentifier: String { get }
    var observer: ObservableEntity { get }
    
    func configureCollectionViewController()
    func configureCollectionViewLayout()
    func configureCollectionViewCell(_ cell: CoreDataCollectionViewCell)
    
    func moveEntity(_ entity: NSManagedObject, from fromIndex: IndexPath, to toIndex: IndexPath)
    
}


class CoreDataCollectionViewController: NSObject {
    
    var collectionView: UICollectionView {
        didSet {
            if self.collectionView !== oldValue {
                self.detach(view: oldValue)
                self.attach(view: self.collectionView)
            }
        }
    }
    
    var layout: UICollectionViewLayout {
        didSet {
            if self.layout !== oldValue {
                self.detach(layout: oldValue)
                self.attach(layout: self.layout)
            }
        }
    }
    
    var cellIdentifier: String
    
    var observer: ObservableEntity
    
    var frc: NSFetchedResultsController<NSFetchRequestResult>? {
        get {
            return self.observer.fetchedResultsController
        }
    }
    
    var isUserDragging = false
    
    
    init(view: UICollectionView, cellIdentifier: String, observer: ObservableEntity,
         layout: UICollectionViewLayout? = nil, populate: Bool = true) {
        self.collectionView = view
        self.cellIdentifier = cellIdentifier
        self.observer = observer
        self.layout = (layout == nil ? UICollectionViewFlowLayout() : layout!)
        
        super.init()
        
        self.attach(view: self.collectionView, populate: populate)
        self.attach(layout: self.layout)
    }
    
    func attach(view: UICollectionView, populate: Bool = true) {
        view.delegate = self
        view.dataSource = self
        self.configureCollectionViewController()
        view.collectionViewLayout = self.layout
        if populate {
            self.observer.populateListener(self)
        }
    }
    
    func attach(layout: UICollectionViewLayout) {
        self.configureCollectionViewLayout()
        self.collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    func detach(layout: UICollectionViewLayout) {
    }
    
    func detach(view: UICollectionView) {
        self.observer.depopulateListener(self)
        view.delegate = nil
        view.dataSource = nil
    }
    
    
    func beginDraggingCell(at location: CGPoint) {
        if let indexPath = self.collectionView.indexPathForItem(at: location) {
            self.isUserDragging = true
            self.collectionView.beginInteractiveMovementForItem(at: indexPath)
        }
    }
    
    func onCellDrag(to location: CGPoint) {
        self.collectionView.updateInteractiveMovementTargetPosition(location)
    }
    
    func endDraggingCell(at location: CGPoint) {
        self.collectionView.endInteractiveMovement()
        self.isUserDragging = false
    }
    
}


extension CoreDataCollectionViewController: CoreDataCollectionViewDelegate {
    
    func configureCollectionViewController() {}
    
    func configureCollectionViewLayout() {}
    
    func configureCollectionViewCell(_ cell: CoreDataCollectionViewCell){ }
    
    func moveEntity(_ entity: NSManagedObject, from fromIndex: IndexPath, to toIndex: IndexPath) {
        // override if enabling item moving
    }
    
}


extension CoreDataCollectionViewController: UICollectionViewDelegate {
    
}


extension CoreDataCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath)
        
        if let entity = self.frc?.object(at: indexPath) as? NSManagedObject,
                let coreDataCell = cell as? CoreDataCollectionViewCell {
            coreDataCell.configure(delegate: self, entity: entity)
            self.configureCollectionViewCell(coreDataCell)
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let sections = self.frc?.sections {
            return sections.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let sections = self.frc?.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath,
                        to destinationIndexPath: IndexPath) {
        if let item = self.collectionView(collectionView, cellForItemAt: sourceIndexPath) as? CoreDataCollectionViewCell {
            self.moveEntity(item.entity, from: sourceIndexPath, to: destinationIndexPath)
        }
    }
    
}


extension CoreDataCollectionViewController: EntityListener {
    
    func onChangeEntity(_ key: String, entity: NSManagedObject, type: NSFetchedResultsChangeType, oldIndex: IndexPath?, newIndex: IndexPath?) {
        if key == self.observer.key {
            switch type {
            case .insert:
                if let insertIndex = newIndex {
                    self.collectionView.insertItems(at: [insertIndex])
                }
                break
                
            case .delete:
                if let deleteIndex = oldIndex {
                    self.collectionView.deleteItems(at: [deleteIndex])
                }
                break
                
            case .update:
                if let updateIndex = oldIndex,
                    let cell = self.collectionView.cellForItem(at: updateIndex)as? CoreDataCollectionViewCell,
                    let entity = self.frc?.object(at: updateIndex) as? NSManagedObject {
                    
                    cell.configure(delegate: self, entity: entity)
                }
                break
                
            case .move:
                if !self.isUserDragging {
                    if let fromIndex = oldIndex, let toIndex = newIndex {
                        self.collectionView.moveItem(at: fromIndex, to: toIndex)
                    }
                }
                break
            }
        }
    }
    
    func onChangeSectionInfo(_ key: String, info: NSFetchedResultsSectionInfo, at index: Int, type: NSFetchedResultsChangeType) {
        if key == self.observer.key {
            let sectionIndex = IndexSet(integer: index)
            
            switch type {
            case .insert:
                self.collectionView.insertSections(sectionIndex)
                break
                
            case .delete:
                self.collectionView.deleteSections(sectionIndex)
                break
                
            default: break
            }
        }
    }
    
}
