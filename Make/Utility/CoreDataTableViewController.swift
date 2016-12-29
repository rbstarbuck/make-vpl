//
//  CoreDataTableViewController.swift
//  Make
//
//  Created by Richmond Starbuck on 12/29/16.
//
//

import UIKit
import CoreData


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
            return self.observer.fetchedResultsController
        }
    }
    
    // optionally set in configureTableViewController
    var insertRowAnimation = UITableViewRowAnimation.fade
    var deleteRowAnimation = UITableViewRowAnimation.fade
    var insertSectionAnimation = UITableViewRowAnimation.fade
    var deleteSectionAnimation = UITableViewRowAnimation.fade
    
    
    init(view: UITableView, cellIdentifier: String, observer: ObservableEntity, populate: Bool = true) {
        self.tableView = view
        self.cellIdentifier = cellIdentifier
        self.observer = observer
        
        super.init()
        
        self.configureTableViewController()
        self.attach(view: self.tableView, populate: populate)
    }
    
    func attach(view: UITableView, populate: Bool = true) {
        view.delegate = self
        view.dataSource = self
        if populate {
            self.observer.populateListener(self)
        }
    }
    
    func detach(view: UITableView) {
        self.observer.depopulateListener(self)
        view.delegate = nil
        view.dataSource = nil
    }

    
    func configureCell(_ cell: UITableViewCell, entity: NSManagedObject) {
        // REQUIRED in subclass
    }
    
    func configureTableViewController() {
        // OPTIONAL in subclass
    }
}


extension CoreDataTableViewController: UITableViewDelegate {
    
    // OPTIONAL: implement UITableViewDelegate methods in subclass
    
}


extension CoreDataTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        
        if let entity = self.frc?.object(at: indexPath) as? NSManagedObject {
            self.configureCell(cell, entity: entity)
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
        
        return 0
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
                    let cell = self.tableView.cellForRow(at: updateIndex),
                    let entity = self.frc?.object(at: updateIndex) as? NSManagedObject {
                    self.configureCell(cell, entity: entity)
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
