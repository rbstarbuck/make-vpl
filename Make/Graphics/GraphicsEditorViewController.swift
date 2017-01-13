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
    @IBOutlet weak var frameCollectionView: UICollectionView!
    @IBOutlet weak var canvasView: CanvasView!
    @IBOutlet weak var brushView: BrushView!
    
    var canvasController: CanvasController!
    var frameController: FrameController!
    var layerController: LayerController!
    var brushController: BrushController!
    
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
        
        let brush = Brush()
        
        self.brushController = BrushController(view: self.brushView, brush: brush)
        self.frameController = FrameController(view: self.frameCollectionView, graphic: self.graphic)
        self.canvasController = CanvasController(view: self.canvasView, graphic: self.graphic, brush: brush)
        self.layerController = LayerController(view: self.layerTableView, graphic: self.graphic)
    }
    
    @IBAction func createLayerTouch(_ sender: Any) {
        if let frame = self.graphic.selectedFrame.value {
            let layer = frame.createLayer()
            frame.selectedLayer.value = layer
        }
    }
    
    @IBAction func deleteFrameTouch(_ sender: Any) {
        self.graphic.selectedFrame.value?.delete()
    }
    
}
