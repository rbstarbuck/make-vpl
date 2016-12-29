//
//  LayerController.swift
//  Make
//
//  Created by Richmond Starbuck on 12/27/16.
//
//

import UIKit
import CoreData


class LayerController: CoreDataTableViewController, LayerDelegate {
    
    var graphic: SCGraphic {
        didSet {
            if self.graphic !== oldValue {
                self.detach(graphic: oldValue)
                self.attach(graphic: self.graphic)
            }
        }
    }
    
    var frame: SCFrame {
        didSet {
            if self.frame !== oldValue {
                self.detach(frame: oldValue)
                self.attach(frame: self.frame)
            }
        }
    }
    
    
    // MARK: - Initialization
    
    init(view: UITableView, graphic: SCGraphic) {
        self.graphic = graphic
        self.frame = graphic.selectedFrame.value!
        
        let nib = UINib(nibName: "LayerTableViewCell", bundle: nil)
        view.register(nib, forCellReuseIdentifier: "LayerTableViewCell")
        
        super.init(view: view, cellIdentifier: "LayerTableViewCell", observer: self.frame.layerObserver)
        
        self.attach(graphic: self.graphic, populate: false)
        self.attach(frame: self.frame, populate: false)
    }
    
    func attach(graphic: SCGraphic, populate: Bool = true) {
        graphic.selectedFrame.addListener(self, populate: populate)
    }
    
    func attach(frame: SCFrame, populate: Bool = true) {
        frame.layerObserver.addListener(self, populate: populate)
        frame.selectedLayer.addListener(self, populate: populate)
    }
    
    func detach(graphic: SCGraphic) {
        graphic.selectedFrame.removeListener(self)
    }
    
    func detach(frame: SCFrame) {
        frame.layerObserver.removeListener(self, depopulate: true)
        frame.selectedLayer.removeListener(self)
    }
    
    
    override func configureTableViewController() {
        
    }
    
    override func configureCell(_ cell: UITableViewCell, entity: NSManagedObject) {
        if let layerCell = cell as? LayerTableViewCell, let layer = entity as? SCLayer {
            layerCell.nameLabel.text = layer.name
        }
    }
    
}


extension LayerController: PropertyListener {
    
    func onPropertyChange(key: String, newValue: Any?, oldValue: Any?) {
        if key == SCGraphic.selectedFrameObserverKey {
            if let newFrame = newValue as? SCFrame {
                self.frame = newFrame
            }
        }
        else if key == SCFrame.selectedLayerObserverKey {
            
        }
    }
    
}
