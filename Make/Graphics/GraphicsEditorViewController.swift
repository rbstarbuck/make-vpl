//
//  GraphicsEditorViewController.swift
//  Make
//
//  Created by Richmond Starbuck on 12/19/16.
//
//

import UIKit
import CoreData


class GraphicsEditorViewController: UIViewController {
    
    @IBOutlet weak var layerTableView: UITableView!
    @IBOutlet weak var canvasView: CanvasView!
    
    var canvasController: CanvasController!
    var layerController: LayerController!

    var world: SCWorld!
    var graphic: SCGraphic!
    
    var connector = SCConnector(context: SCCoreDataStack())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let worlds = self.connector.getWorlds()
        if let world = worlds.first {
            self.world = world
        }
        else {
            self.world = self.connector.createWorld()
        }
        
        if let graphic = self.world.graphics.first {
            self.graphic = graphic
        }
        else {
            self.graphic = self.world.createGraphic()
        }
        
        self.canvasController = CanvasController(view: self.canvasView, graphic: self.graphic)
        self.layerController = LayerController(view: self.layerTableView, graphic: self.graphic)
    }
    
    @IBAction func createLayerTouch(_ sender: Any) {
        if let frame = self.graphic.selectedFrame.value {
            let layer = frame.createLayer()
            frame.selectedLayer.value = layer
        }
    }
}
