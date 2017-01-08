//
//  CoreDataCollectionViewCell.swift
//  Make
//
//  Created by Richmond Starbuck on 12/31/16.
//
//

import UIKit
import CoreData


class CoreDataCollectionViewCell: UICollectionViewCell {
    
    var delegate: CoreDataCollectionViewDelegate!
    var entity: NSManagedObject!
    
    
    func configure(delegate: CoreDataCollectionViewDelegate, entity: NSManagedObject) {
        self.delegate = delegate
        self.entity = entity
    }
}
