//
//  GraphicsEditorViewController.swift
//  Make
//
//  Created by Richmond Starbuck on 12/19/16.
//
//

import UIKit

class GraphicsEditorViewController: UIViewController {
    
    @IBOutlet weak var canvasView: CanvasView!
    
    var connector = SCConnector(context: SCCoreDataStack())
    
    var canvasController = CanvasController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let world = connector.createWorld()
        let graphic = world.createGraphic()
        
        self.canvasController.frame = graphic.frames.first!
        self.canvasView.delegate = self.canvasController
    }

}
