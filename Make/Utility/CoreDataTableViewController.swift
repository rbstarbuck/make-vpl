//
//  CoreDataTableViewController.swift
//
//  Created by Richmond Starbuck on 12/29/16.
//
//

import UIKit
import CoreData


protocol CoreDataTableViewDelegate {
    
    var tableView: UITableView { get }
    var cellIdentifier: String { get }
    var observer: ObservableEntity { get }
    
    // (optional) implement to modify default base class properties (e.g. animation types)
    func configureTableViewController()
    
    // (optional) implement if enabling cell reordering via dragging
    func moveEntity(_ entity: NSManagedObject, from fromIndex: IndexPath, to toIndex: IndexPath)
    
    // call if implementing reordering via dragging (do not override)
    func beginDraggingCell(at point: CGPoint)
    func onCellDrag(to point: CGPoint)
    func endDraggingCell(at point: CGPoint)
    
}


class CoreDataTableViewController: NSObject {

    var tableView: UITableView {
        didSet {
            if self.tableView !== oldValue {
                self.detach(view: oldValue)
                self.attach(view: self.tableView)
            }
        }
    }
    
    var cellIdentifier: String
    
    var observer: ObservableEntity
    
    var frc: NSFetchedResultsController<NSFetchRequestResult>? {
        get {
            if self.observer.containsListener(self) {
                return self.observer.fetchedResultsController
            }
            return nil
        }
    }
    
    var insertRowAnimation = UITableViewRowAnimation.fade
    var deleteRowAnimation = UITableViewRowAnimation.fade
    var insertSectionAnimation = UITableViewRowAnimation.fade
    var deleteSectionAnimation = UITableViewRowAnimation.fade

    
    var cellSnapshot: UIView?
    var draggedCell: CoreDataTableViewCell?
    var previousDragIndexPath = IndexPath()
    
    
    init(view: UITableView, cellIdentifier: String, observer: ObservableEntity, populate: Bool = true) {
        self.tableView = view
        self.cellIdentifier = cellIdentifier
        self.observer = observer
        
        super.init()
        
        self.attach(view: self.tableView, populate: populate)
    }
    
    func attach(view: UITableView, populate: Bool = true) {
        view.delegate = self
        view.dataSource = self
        self.configureTableViewController()
        if populate {
            self.observer.populateListener(self)
        }
    }
    
    func detach(view: UITableView) {
        self.observer.depopulateListener(self)
        view.delegate = nil
        view.dataSource = nil
    }
    
    func configureTableViewController() {}
    
}


extension CoreDataTableViewController: CoreDataTableViewDelegate {
    
    func beginDraggingCell(at point: CGPoint) {
        if self.draggedCell != nil {
            self.endDraggingCell(at: point)
        }
        
        if let indexPath = self.tableView.indexPathForRow(at: point),
            let draggedCell = self.tableView.cellForRow(at: indexPath) as? CoreDataTableViewCell,
            let cellSnapshot = self.snapshot(from: draggedCell) {
            
            self.previousDragIndexPath = indexPath
            self.draggedCell = draggedCell
            self.cellSnapshot = cellSnapshot
            
            cellSnapshot.center = draggedCell.center
            cellSnapshot.alpha = 0.0
            
            self.tableView.addSubview(cellSnapshot)
            
            UIView.animate(withDuration: 0.25, animations: {
                cellSnapshot.center.y = point.y
                cellSnapshot.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                cellSnapshot.alpha = 0.98
                draggedCell.alpha = 0.0
            }, completion: {_ in
                draggedCell.isHidden = true
            })
        }
    }
    
    func onCellDrag(to point: CGPoint) {
        if let cellSnapshot = self.cellSnapshot,
            let newIndexPath = self.tableView.indexPathForRow(at: point) {
            
            cellSnapshot.center.y = point.y
            
            if newIndexPath != self.previousDragIndexPath {
                self.moveEntity(self.draggedCell!.entity, from: self.previousDragIndexPath, to: newIndexPath)
                self.previousDragIndexPath = newIndexPath
            }
        }
    }
    
    func endDraggingCell(at point: CGPoint) {
        if let draggedCell = self.draggedCell {
            draggedCell.isHidden = false
            
            UIView.animate(withDuration: 0.25, animations: {
                if let cellSnapshot = self.cellSnapshot {
                    cellSnapshot.center = draggedCell.center
                    cellSnapshot.transform = CGAffineTransform.identity
                    cellSnapshot.alpha = 0.0
                }
                draggedCell.alpha = 1.0
            }, completion: {_ in
                self.cellSnapshot?.removeFromSuperview()
                self.cellSnapshot = nil
            })
            
            self.draggedCell = nil
        }
    }
    
    func snapshot(from view: UIView) -> UIView? {
        if let snapshot = view.snapshotView(afterScreenUpdates: true) {
            snapshot.layer.masksToBounds = false
            snapshot.layer.cornerRadius = 0.0
            snapshot.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            snapshot.layer.shadowRadius = 4.0
            snapshot.layer.shadowOpacity = 1.0
            
            return snapshot
        }
        else {
            print("ERROR: couldn't create snapshot from \(view)")
        }
        
        return nil
    }
    
    func moveEntity(_ entity: NSManagedObject, from fromIndex: IndexPath, to toIndex: IndexPath) {}
    
}


extension CoreDataTableViewController: UITableViewDelegate {
    
    // OPTIONAL: implement UITableViewDelegate methods in subclass
    
}


extension CoreDataTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        
        if let entity = self.frc?.object(at: indexPath) as? NSManagedObject,
            let coreDataCell = cell as? CoreDataTableViewCell {
            
            coreDataCell.configure(delegate: self, entity: entity)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = self.frc?.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = self.frc?.sections {
            return sections.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String?
        
        if let sections = self.frc?.sections {
            let currentSection = sections[section]
            title = currentSection.name
            
            if let titleDelegate = self.observer.sectionTitleDelegate {
                title = titleDelegate.sectionTitle(for: title!)
            }
        }
        
        return nil
    }
    
}


extension CoreDataTableViewController: EntityListener {
    
    func willChangeEntity(_ key: String) {
        if key == self.observer.key {
            self.tableView.beginUpdates()
        }
    }
    
    func onChangeEntity(_ key: String, entity: NSManagedObject, type: NSFetchedResultsChangeType, oldIndex: IndexPath?, newIndex: IndexPath?) {
        if key == self.observer.key {
            switch type {
            case .insert:
                if let insertIndex = newIndex {
                    self.tableView.insertRows(at: [insertIndex], with: self.insertRowAnimation)
                }
                break
                
            case .delete:
                if let deleteIndex = oldIndex {
                    self.tableView.deleteRows(at: [deleteIndex], with: self.deleteRowAnimation)
                }
                break
                
            case .update:
                if let updateIndex = oldIndex,
                    let cell = self.tableView.cellForRow(at: updateIndex) as? CoreDataTableViewCell,
                    let entity = self.frc?.object(at: updateIndex) as? NSManagedObject {
                    
                    cell.configure(delegate: self, entity: entity)
                }
                break
                
            case .move:
                if let fromIndex = oldIndex, let toIndex = newIndex {
                    self.tableView.moveRow(at: fromIndex, to: toIndex)
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
                self.tableView.insertSections(sectionIndex, with: self.insertSectionAnimation)
                break
                
            case .delete:
                self.tableView.deleteSections(sectionIndex, with: self.deleteSectionAnimation)
                break
                
            default: break
            }
        }
    }
    
    func didChangeEntity(_ key: String) {
        if key == self.observer.key {
            self.tableView.endUpdates()
        }
    }
    
}
