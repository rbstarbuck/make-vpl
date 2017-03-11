//
//  SpritesEditorViewController.swift
//  Make
//
//  Created by Richmond Starbuck on 1/19/17.
//
//

import UIKit

class SpritesEditorViewController: UIViewController {
    
    @IBOutlet weak var physicsPropertiesView: PhysicsPropertiesView!
    
    var connector: SCConnector!
    var sprite: SCSprite!
    
    var physicsPropertiesController: PhysicsPropertiesDelegate!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(SCConstants.SPRITE_DISPLAY_TITLE): \"\(self.sprite.name)\""
        self.edgesForExtendedLayout = UIRectEdge()
        self.view.layoutSubviews()

        self.physicsPropertiesController = PhysicsPropertiesController(view: self.physicsPropertiesView,
                                                                       physicsBody: self.sprite.physicsBody)
    }

}
