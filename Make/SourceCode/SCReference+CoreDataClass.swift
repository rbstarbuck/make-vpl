//
//  SCReference+CoreDataClass.swift
//  Make
//
//  Created by Richmond Starbuck on 2/25/17.
//
//

import UIKit
import CoreData


public class SCReference: NSManagedObject {
    public static let entityName = "Reference"
    
    public static let defaultRelativeWidth = 0.2
    public static let minimumRelativeWidth = 0.025
    public static let maximumRelativeWidth = 1.0
    
        
    @NSManaged public var id: String
    @NSManaged public var animated: Bool
    @NSManaged public var centerX: Double
    @NSManaged public var centerY: Double
    @NSManaged public var relativeWidth: Double
    @NSManaged public var rotation: Double
    @NSManaged public var flipX: Bool
    @NSManaged public var flipY: Bool
    @NSManaged public var sprite: SCSprite
    @NSManaged public var scene: SCScene
    
    
    public override func awakeFromInsert() {
        self.id = UUID().uuidString
    }
    
    
    func scale(in viewSize: CGSize) -> CGFloat {
        let image = self.sprite.editorImage
        return viewSize.width * CGFloat(self.relativeWidth) / image.width
    }
    
    func size(in viewSize: CGSize) -> CGSize {
        let dim = viewSize.width * CGFloat(self.relativeWidth)
        return CGSize(width: dim, height: dim)
    }
    
    func center(in viewFrame: CGRect) -> CGPoint {
        let xPos = viewFrame.width * CGFloat(self.centerX)
        let yPos = viewFrame.height * CGFloat(self.centerY)
        return CGPoint(x: viewFrame.origin.x + xPos, y: viewFrame.origin.y + yPos)
    }
    
    func gameplayCenter(in viewFrame: CGRect) -> CGPoint {
        let xPos = viewFrame.width * CGFloat(self.centerX)
        let yPos = viewFrame.height * CGFloat(-self.centerY) + viewFrame.height
        return CGPoint(x: viewFrame.origin.x + xPos, y: viewFrame.origin.y + yPos)
    }
    
    func frame(in viewFrame: CGRect) -> CGRect {
        let dim = viewFrame.size.width * CGFloat(self.relativeWidth)
        let offset = dim / 2.0
        let center = self.center(in: viewFrame)
        return CGRect(x: center.x - offset, y: center.y - offset, width: dim, height: dim)
    }
    
}
