//
//  GraphicSelectionCollectionViewCell.swift
//  Make
//
//  Created by Richmond Starbuck on 2/26/17.
//
//

import UIKit
import CoreData


class GraphicSelectionCollectionViewCell: CoreDataCollectionViewCell {
    static let cellIdentifier = "GraphicSelectionCollectionViewCell"

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var editImageButton: UIButton!
    
    
    override func configure(delegate: CoreDataCollectionViewDelegate, entity: NSManagedObject) {
        super.configure(delegate: delegate, entity: entity)
        
        if let graphic = entity as? SCGraphic {
            self.imageView.image = graphic.firstFrame.makeImageFromLayers()
        }
    }
    
}
