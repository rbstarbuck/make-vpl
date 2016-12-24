//
//  SCLayerTests.swift
//  Make
//
//  Created by Richmond Starbuck on 12/24/16.
//
//

import XCTest
import CoreData
@testable import Make

class SCLayerTests: XCTestCase {
    
    var connector: SCConnector!
    var frame: SCFrame!
    var layer: SCLayer!
    
    override func setUp() {
        super.setUp()
        self.connector = SCConnector(context: CoreDataTestStack())
        let world = connector.createWorld()
        let graphic = world.createGraphic()
        
        self.frame = graphic.frames.first!
        self.layer = self.frame.layers.first!
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssert(self.layer.frame === self.frame)
        XCTAssert(self.layer.index == 0)
    }
    
    func testImageView() {
        XCTAssert(self.layer.imageView.image === self.layer.image)
        let oldImageViewImage = self.layer.imageView.image
        
        self.layer.image = UIImage()
        XCTAssert(self.layer.imageView.image === self.layer.image)
        XCTAssert(oldImageViewImage !== self.layer.image)
    }
    
    func testSave() {
        XCTAssert(self.connector.saveContext())
        
        self.layer.name = "a new name"
        
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        let renderer = UIGraphicsImageRenderer(size: rect.size)
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addRect(rect)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        self.layer.image = img
        
        XCTAssert(self.connector.saveContext())
        
        let req: NSFetchRequest<SCLayer> = SCLayer.fetchRequest()
        do {
            let result = try self.connector.context.fetch(req)
            XCTAssert(result.count == 1)
            
            let fetchedLayer = result.first!
            XCTAssert(self.layer.index == fetchedLayer.index)
            XCTAssert(self.layer.name == fetchedLayer.name)
            XCTAssert(fetchedLayer.image.size == rect.size)
            XCTAssert(UIImagePNGRepresentation(self.layer.image) == UIImagePNGRepresentation(fetchedLayer.image))
        }
        catch {
            XCTAssert(false)
        }
    }
    
}
