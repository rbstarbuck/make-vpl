//
//  SCGraphicTests.swift
//  Make
//
//  Created by Richmond Starbuck on 12/23/16.
//
//

import XCTest
import CoreData
@testable import Make


class SCGraphicTests: XCTestCase {
    
    var connector: SCConnector!
    var graphic: SCGraphic!
    
    override func setUp() {
        super.setUp()
        self.connector = SCConnector(context: CoreDataTestStack())
        let world = connector.createWorld()
        
        self.graphic = world.createGraphic()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssert(self.graphic.id.characters.count == UUID().uuidString.characters.count)
        XCTAssert(self.graphic.frames.count == 1)
    }
    
    func testFrameOrder() {
        var frames = [self.graphic.frames.first!]
        
        XCTAssert(frames[0].index == 0)
        
        for i in 1...4 {
            let frame = self.graphic.createFrame()
            XCTAssert(frame.index == i)
            frames.append(frame)
        }
        
        frames[0].move(to: 4)
        frames[4].move(to: 1)
        frames[1].moveUp()
        frames[2].moveDown()
        
        XCTAssert(frames[4].index == 0)
        XCTAssert(frames[2].index == 1)
        XCTAssert(frames[1].index == 2)
        XCTAssert(frames[3].index == 3)
        XCTAssert(frames[0].index == 4)
        
        XCTAssert(self.graphic.createFrame().index == 5)
    }
    
    func testSortFrames() {
        for _ in 1...4 {
            self.graphic.createFrame()
        }
        
        var index = 0
        for frame in self.graphic.sortedFrames {
            XCTAssert(frame.index == index)
            index += 1
        }
    }
    
    func testSave() {
        XCTAssert(self.connector.saveContext())
        
        self.graphic.name = "a new name"
        self.graphic.animationFPS = 123
        self.graphic.createFrame()
        
        XCTAssert(self.connector.saveContext())
        
        let req: NSFetchRequest<SCGraphic> = SCGraphic.fetchRequest()
        do {
            let result = try self.connector.context.fetch(req)
            XCTAssert(result.count == 1)
            
            let fetchedGraphic = result.first!
            XCTAssert(self.graphic.id == fetchedGraphic.id)
            XCTAssert(self.graphic.name == fetchedGraphic.name)
            XCTAssert(self.graphic.animationFPS == fetchedGraphic.animationFPS)
            XCTAssert(self.graphic.frames.count == fetchedGraphic.frames.count)
        }
        catch {
            XCTAssert(false)
        }
    }
    
}
