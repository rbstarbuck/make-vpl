//
//  PysicsEditorView.swift
//  Make
//
//  Created by Richmond Starbuck on 3/19/17.
//
//

import UIKit

class PhysicsView: UIViewFromNib {

    @IBOutlet weak var shapeView: PhysicsShapeView!
    @IBOutlet weak var propertiesView: PhysicsPropertiesView!
    
    
    func configure() {
        self.shapeView.configure()
        self.propertiesView.configure()
    }
}
