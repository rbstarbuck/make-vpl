//
//  CoreDataTableViewCell.swift
//
//  Created by Richmond Starbuck on 12/29/16.
//
//

import UIKit
import CoreData


class CoreDataTableViewCell: UITableViewCell {

    var delegate: CoreDataTableViewDelegate!
    var entity: NSManagedObject!
    
    func configure(delegate: CoreDataTableViewDelegate, entity: NSManagedObject) {
        self.delegate = delegate
        self.entity = entity
    }
}
