//
//  SelectionCollectionViewCell.swift
//  Make
//
//  Created by Richmond Starbuck on 3/23/17.
//
//

import UIKit
import CoreData


private let cellCornerRadius = CGFloat(10)
private let cellBorderColor = UIColor.lightGray
private let cellBorderWidth = CGFloat(1)


class SelectionCollectionViewCell: CoreDataCollectionViewCell {
    static let cellIdentifier = "SelectionCollectionViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    
    override func configure(delegate: CoreDataCollectionViewDelegate, entity: NSManagedObject) {
        super.configure(delegate: delegate, entity: entity)
        
        self.cornerRadius = cellCornerRadius
        self.borderColor = cellBorderColor
        self.borderWidth = cellBorderWidth
        
        if let controller = delegate as? SelectionDelegate {
            self.imageView.image = controller.getImage?(entity)
            self.label.text = controller.getLabel?(entity)
        }
    }

}
