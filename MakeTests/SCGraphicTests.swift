//
//  SCGraphicTests.swift
//  MakeTests
//
//  Created by Richmond Starbuck on 11/28/16.
//
//

import XCTest
@testable import Make

class SCGraphicTests: XCTestCase {
    
    var graphic: SCGraphic?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let connector = SCConnector(context: CoreDataTestStack())
        let world = connector.createWorld()
        let test = world?.id
        self.graphic = world?.createGraphic()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssert(self.graphic != nil)
        //XCTAssert(self.graphic!.id?.characters.count == UUID().uuidString.characters.count)
        XCTAssert(self.graphic!.frames.count == 1)
        
        let frame = self.graphic!.frames.first!
        XCTAssert(frame.graphic === self.graphic!)
        XCTAssert(frame.layers.count == 1)
        
        let layer = frame.layers.first!
        XCTAssert(layer.frame === frame)
    }
    
    func testLayerOrder() {
        let frame = self.graphic!.frames.first!
        var layers = [frame.layers.first!]
        
        XCTAssert(layers[0].index == 0)
        
        for i in 1...4 {
            let layer = frame.createLayer()!
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
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
