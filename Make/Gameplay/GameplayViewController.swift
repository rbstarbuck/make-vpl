//
//  GameplayViewController.swift
//  Make
//
//  Created by Richmond Starbuck on 2/25/17.
//
//

import UIKit


class GameplayViewController: UIViewController {
    
    @IBOutlet weak var sceneView: OCSceneView!
    
    var connector: SCConnector!
    var world: OCWorld!
    
    var sceneController: OCSceneController!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge()
        self.view.layoutSubviews()
        
        self.sceneController = OCSceneController(view: self.sceneView, scene: self.world.activeScene)
    }
    
}
