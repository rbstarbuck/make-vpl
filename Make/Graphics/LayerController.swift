//
//  LayerController.swift
//  Make
//
//  Created by Richmond Starbuck on 12/27/16.
//
//

import UIKit
import CoreData


class LayerController: CoreDataTableViewController {
    static let layerCellIdentifier = "LayerTableViewCell"
    
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
        
        let nib = UINib(nibName: LayerController.layerCellIdentifier, bundle: nil)
        view.register(nib, forCellReuseIdentifier: LayerController.layerCellIdentifier)
        
        super.init(view: view, cellIdentifier: LayerController.layerCellIdentifier, observer: self.frame.layerObserver, populate: false)
        
        self.attach(graphic: self.graphic, populate: false)
        self.attach(frame: self.frame, populate: true)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler(_:)))
        self.tableView.addGestureRecognizer(longPress)
    }
    
    private func attach(graphic: SCGraphic, populate: Bool = true) {
        graphic.selectedFrame.addListener(self, populate: populate)
    }
    
    private func attach(frame: SCFrame, populate: Bool = true) {
        self.observer = frame.layerObserver
        frame.layerObserver.addListener(self, populate: populate)
        frame.selectedLayer.addListener(self, populate: populate)
    }
    
    private func detach(graphic: SCGraphic) {
        graphic.selectedFrame.removeListener(self)
    }
    
    private func detach(frame: SCFrame) {
        frame.layerObserver.removeListener(self, depopulate: true)
        frame.selectedLayer.removeListener(self)
    }
    
    
    // MARK: - CoreDataTableViewController methods
    
    override func configureTableViewController() {
        self.insertRowAnimation = .right
        self.deleteRowAnimation = .left
    }
    
    override func moveEntity(_ entity: NSManagedObject, from fromIndex: IndexPath, to toIndex: IndexPath) {
        if let layer = entity as? SCLayer {
            layer.move(to: toIndex.row)
        }
    }
    
    
    // MARK: - Interaction handlers
    
    func longPressHandler(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: self.tableView)
        
        switch sender.state {
        case .began:
            if let indexPath = self.tableView.indexPathForRow(at: location),
                let cell = self.tableView.cellForRow(at: indexPath) as? LayerTableViewCell,
                let layer = cell.entity as? SCLayer {
                
                layer.select()
            }
            self.beginDraggingCell(at: location)
            break
            
        case .changed:
            self.onCellDrag(to: location)
            break
            
        default:
            self.endDraggingCell(at: location)
            break
        }
    }
    
}


extension LayerController {
    
    /*override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reverseIndexPath = self.reverseIndexPath(indexPath)
        return super.tableView(tableView, cellForRowAt: reverseIndexPath)
    }*/
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = self.tableView(tableView, cellForRowAt: indexPath) as? LayerTableViewCell,
            let layer = cell.entity as? SCLayer {
            
            self.frame.selectedLayer.value = layer
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
            if let previousLayer = oldValue as? SCLayer {
                let indexPath = IndexPath(row: previousLayer.index, section: 0)
                self.tableView.deselectRow(at: indexPath, animated: true)
            }
            if let selectedLayer = newValue as? SCLayer {
                let indexPath = IndexPath(row: selectedLayer.index, section: 0)
                self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
            }
        }
    }
    
}
