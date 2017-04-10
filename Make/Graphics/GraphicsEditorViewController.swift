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
    
    @IBOutlet weak var nameTextField: NameTextField!
    @IBOutlet weak var layerTableView: UITableView!
    @IBOutlet weak var frameCollectionView: UICollectionView!
    @IBOutlet weak var canvasView: CanvasView!
    @IBOutlet weak var brushView: BrushView!
    
    var connector: SCConnector!
    var graphic: SCGraphic!
    
    var canvasController: CanvasController!
    var frameController: FrameController!
    var layerController: LayerController!
    var brushController: BrushController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setName(self.graphic.name)
        self.edgesForExtendedLayout = UIRectEdge()
        self.view.layoutSubviews()
        
        self.nameTextField.listeners.insert(self)
        self.nameTextField.entity = self.graphic
        
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

extension GraphicsEditorViewController: NameTextFieldListener {
    
    func setName(_ name: String) {
        self.title = "\(SCConstants.GRAPHIC_DISPLAY_TITLE): \"\(name)\""
    }
    
}
