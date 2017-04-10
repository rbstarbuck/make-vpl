//
//  FrameCollectionViewCell.swift
//  Make
//
//  Created by Richmond Starbuck on 12/31/16.
//
//

import UIKit
import CoreData


private let selectedBorderColor = UIColor.magenta
private let cellBackgroundColor = UIColor(hex: 0xf8f8f8)


class FrameCollectionViewCell: CoreDataCollectionViewCell {

    var imageView: UIImageView?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = cellBackgroundColor
        
        let selectedBackgroundView = UIView(frame: self.contentView.frame)
        selectedBackgroundView.backgroundColor = selectedBorderColor
        self.selectedBackgroundView = selectedBackgroundView
    }
    
    
    override func configure(delegate: CoreDataCollectionViewDelegate, entity: NSManagedObject) {
        super.configure(delegate: delegate, entity: entity)
        
        if let oldImageView = self.imageView {
            oldImageView.removeFromSuperview()
            self.imageView = nil
        }
        
        if let frame = entity as? SCFrame {
            self.imageView = frame.makeImageView()
            self.imageView!.backgroundColor = cellBackgroundColor
            self.addSubview(self.imageView!)
            self.imageView!.constrainEdgesToParent(self, margin: 2.5)
        }
    }
    
}
