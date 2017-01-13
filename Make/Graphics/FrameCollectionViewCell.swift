//
//  FrameCollectionViewCell.swift
//  Make
//
//  Created by Richmond Starbuck on 12/31/16.
//
//

import UIKit
import CoreData


class FrameCollectionViewCell: CoreDataCollectionViewCell {

    var imageView: UIImageView?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func configure(delegate: CoreDataCollectionViewDelegate, entity: NSManagedObject) {
        super.configure(delegate: delegate, entity: entity)
        
        if let oldImageView = self.imageView {
            oldImageView.removeFromSuperview()
            self.imageView = nil
        }
        
        if let frame = entity as? SCFrame {
            self.imageView = frame.makeImageView()
            self.addSubview(self.imageView!)
            self.imageView!.constrainEdgesToParent(self)
        }
    }
    
}
