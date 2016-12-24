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

class SCFrameTests: XCTestCase {
    
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
    
}