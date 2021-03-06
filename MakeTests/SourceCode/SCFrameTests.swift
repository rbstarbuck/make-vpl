//
//  SCFrameTests.swift
//  MakeTests
//
//  Created by Richmond Starbuck on 11/28/16.
//
//

import XCTest
import CoreData
@testable import Make

class SCFrameTests: XCTestCase, EntityListener, PropertyListener {
    
    var connector: SCConnector!
    var graphic: SCGraphic!
    var frame: SCFrame!
    
    override func setUp() {
        super.setUp()
        self.connector = SCConnector(context: CoreDataTestStack())
        let world = connector.createWorld()
        
        self.graphic = world.createGraphic()
        self.frame = graphic.frames.first!
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssert(self.frame.graphic === self.graphic)
        XCTAssert(self.frame.layers.count == 1)
    }
    
    func testLayerOrder() {
        var layers = [self.frame.layers.first!]
        
        XCTAssert(layers[0].index == 0)
        
        for i in 1...4 {
            let layer = self.frame.createLayer()
            XCTAssert(layer.index == i)
            layers.append(layer)
        }
        
        layers[0].move(to: 4)
        layers[4].move(to: 1)
        layers[1].moveUp()
        layers[2].moveDown()
        
        XCTAssert(layers[4].index == 0)
        XCTAssert(layers[2].index == 1)
        XCTAssert(layers[1].index == 2)
        XCTAssert(layers[3].index == 3)
        XCTAssert(layers[0].index == 4)
        
        XCTAssert(self.frame.createLayer().index == 5)
    }
    
    func testSortLayers() {
        self.frame.layers.first!.name = "0"
        for i in 1...4 {
            let layer = self.frame.createLayer()
            layer.name = "\(i)"
        }
        
        var index = 0
        for layer in self.frame.sortedLayers {
            XCTAssert(layer.name == "\(index)")
            index += 1
        }
    }
    
    func testCopyLayers() {
        self.frame.layers.first!.name = "0"
        for i in 1...2 {
            let layer = self.frame.createLayer()
            layer.name = "\(i)"
        }
        
        let otherFrame = self.graphic.createFrame()
        otherFrame.layers.first!.name = "3"
        for i in 1...2 {
            let layer = otherFrame.createLayer()
            layer.name = "\(i + 3)"
        }
        
        self.frame.copyLayers(from: otherFrame)
        
        XCTAssert(self.frame.layers.count == 6)
        
        let sortedLayers = self.frame.sortedLayers
        for index in 0..<sortedLayers.count {
            XCTAssert(sortedLayers[index].name == "\(index)")
        }
    }
    
    func testSave() {
        XCTAssert(self.connector.saveContext())
        
        self.frame.createLayer()
        
        XCTAssert(self.connector.saveContext())
        
        let req: NSFetchRequest<SCFrame> = SCFrame.fetchRequest()
        do {
            let result = try self.connector.context.fetch(req)
            XCTAssert(result.count == 1)
            
            let fetchedFrame = result.first!
            XCTAssert(self.frame.index == fetchedFrame.index)
            XCTAssert(self.frame.layers.count == fetchedFrame.layers.count)
        }
        catch {
            XCTAssert(false)
        }
    }
    
    func testDelete() {
        self.graphic.createFrame()
        self.graphic.createFrame()
        self.graphic.createFrame()
        self.graphic.createFrame()
        
        // delete a middle frame
        var target = self.graphic.sortedFrames[2]
        XCTAssert(target.index == 2)
        self.graphic.selectedFrame.value = target
        target.delete()
        
        XCTAssert(self.graphic.frames.count == 4)
        var frames = self.graphic.sortedFrames
        for i in 0..<4 {
            XCTAssert(frames[i].index == i)
        }
        XCTAssert(self.graphic.selectedFrame.value == frames[2])
        
        // delete the last frame
        target = self.graphic.sortedFrames.last!
        self.graphic.selectedFrame.value = target
        target.delete()
        
        XCTAssert(self.graphic.frames.count == 3)
        frames = self.graphic.sortedFrames
        for i in 0..<3 {
            XCTAssert(frames[i].index == i)
        }
        XCTAssert(self.graphic.selectedFrame.value == frames.last!)
        
        // delete remaining
        XCTAssert(self.graphic.sortedFrames.first!.delete())
        XCTAssert(self.graphic.sortedFrames.first!.delete())
        XCTAssert(!self.graphic.sortedFrames.first!.delete())
        
        let req: NSFetchRequest<SCFrame> = SCFrame.fetchRequest()
        do {
            let result = try self.connector.context.fetch(req)
            XCTAssert(result.count == 1)
        }
        catch {
            XCTAssert(false)
        }
    }
    
    
    var newSelectedLayer: SCLayer?
    var oldSelectedLayer: SCLayer?
    
    func testSelectedFrameObserver() {
        let layer0 = self.frame.layers.first!
        self.frame.selectedLayer.addListener(self, populate: true)
        
        XCTAssert(self.newSelectedLayer == layer0)
        XCTAssert(self.oldSelectedLayer == nil)
        
        let layer1 = self.frame.createLayer()
        self.frame.selectedLayer.value = layer1
        
        XCTAssert(self.newSelectedLayer == layer1)
        XCTAssert(self.oldSelectedLayer == layer0)
        
        let didRemove = self.frame.selectedLayer.removeListener(self, depopulate: true)
        
        XCTAssert(didRemove)
        XCTAssert(self.newSelectedLayer == nil)
        XCTAssert(self.oldSelectedLayer == layer1)
    }
    
    func onPropertyChange(key: String, newValue: Any?, oldValue: Any?) {
        XCTAssert(key == SCFrame.selectedLayerObserverKey)
        self.newSelectedLayer = newValue as? SCLayer
        self.oldSelectedLayer = oldValue as? SCLayer
    }
    
    
    var isChanging = false
    var onChangeType: NSFetchedResultsChangeType = .insert
    var onChangeObject: NSManagedObject?
    var onChangeOldIndex: IndexPath?
    var onChangeNewIndex: IndexPath?
    
    func testFrameObserver() {
        self.frame.layerObserver.addListener(self)
        let layer1 = self.frame.createLayer()
        
        let layer2 = self.frame.createLayer()
        XCTAssert(self.onChangeType == .insert)
        XCTAssert(self.onChangeObject == layer2)
        XCTAssert(self.onChangeOldIndex == nil)
        XCTAssert(self.onChangeNewIndex!.section == 0)
        XCTAssert(self.onChangeNewIndex!.row == 2)
        
        layer2.move(to: 0)
        XCTAssert(self.onChangeType == .move)
        XCTAssert(self.onChangeObject == layer2)
        XCTAssert(self.onChangeOldIndex!.section == 0)
        XCTAssert(self.onChangeOldIndex!.row == 2)
        XCTAssert(self.onChangeNewIndex!.section == 0)
        XCTAssert(self.onChangeNewIndex!.row == 0)
        
        layer1.delete()
        XCTAssert(self.onChangeType == .delete)
        XCTAssert(self.onChangeObject == layer1)
        XCTAssert(self.onChangeOldIndex!.section == 0)
        XCTAssert(self.onChangeOldIndex!.row == 2)
        XCTAssert(self.onChangeNewIndex == nil)
    }
    
    func willChangeEntity(_ key: String) {
        self.isChanging = true
    }
    
    func onChangeEntity(_ key: String, entity: NSManagedObject, type: NSFetchedResultsChangeType, oldIndex: IndexPath?, newIndex: IndexPath?) {
        XCTAssert(self.isChanging)
        XCTAssert(key == SCFrame.layerObserverKey)
        self.onChangeType = type
        self.onChangeObject = entity
        self.onChangeOldIndex = oldIndex
        self.onChangeNewIndex = newIndex
    }
    
    func didChangeEntity(_ key: String) {
        self.isChanging = false
    }
    
}
