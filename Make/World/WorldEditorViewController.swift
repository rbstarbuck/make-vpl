//
//  WorldEditorViewController.swift
//  Make
//
//  Created by Richmond Starbuck on 2/26/17.
//
//

import UIKit
import CoreData


class WorldEditorViewController: UIViewController {
    static let graphicsEditorSegueIdentifier = "GraphicsEditorViewControllerSegue"
    static let spritesEditorSegueIdentifier = "SpritesEditorViewControllerSegue"
    
    static let graphicCellIdentifier = "GraphicSelectionCollectionViewCell"
    
    
    @IBOutlet weak var graphicSelectionView: SelectionView!
    
    var connector: SCConnector!
    var world: SCWorld!
    
    var graphicSelectionController: SelectionController!
    
    var selectedEntity: NSManagedObject?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: delete test code
        self.connector = SCConnector(context: SCCoreDataStack())
        if let world = self.connector.getWorlds().first {
            self.world = world
        }
        else {
            self.world = self.connector.createWorld()
        }
//        let graphic = self.world.graphics.first!
//        for _ in 0..<10 {
//            let next = self.world.createGraphic()
//            next.frames.first!.copyLayers(from: graphic.frames.first!)
//        }
//        let count = self.world.graphics.count
        // end test code
        
        self.title = "\(SCConstants.WORLD_DISPLAY_TITLE): \"\(self.world.name)\""
        self.edgesForExtendedLayout = UIRectEdge()
        self.view.layoutSubviews()
        
        self.graphicSelectionController = SelectionController(dataSource: self,
                                                              view: self.graphicSelectionView,
                                                              name: SCConstants.GRAPHIC_DISPLAY_TITLE,
                                                              cellIdentifier: WorldEditorViewController.graphicCellIdentifier,
                                                              observer: self.world.graphicObserver)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.graphicSelectionView.collectionView.reloadData()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case WorldEditorViewController.spritesEditorSegueIdentifier:
                if let spritesEditor = segue.destination as? SpritesEditorViewController {
                    spritesEditor.connector = self.connector
                    spritesEditor.sprite = self.selectedEntity as! SCSprite
                }
                break
                
            case WorldEditorViewController.graphicsEditorSegueIdentifier:
                if let graphicsEditor = segue.destination as? GraphicsEditorViewController {
                    graphicsEditor.connector = self.connector
                    graphicsEditor.graphic = self.selectedEntity as! SCGraphic
                }
                break
                
            default: break
            }
        }
    }

}


extension WorldEditorViewController: SelectionDataSource {
    
    func createEntity(name: String) {
        var entity: NSManagedObject!
        
        switch name {
        case SCConstants.SCENE_DISPLAY_TITLE: return
            
        case SCConstants.SPRITE_DISPLAY_TITLE:
            entity = self.world.createSprite()
            break
            
        case SCConstants.GRAPHIC_DISPLAY_TITLE:
            entity = self.world.createGraphic()
            break
        
        default: return
        }
        
        self.didSelectEntity(entity, name: name)
    }
    
    func didSelectEntity(_ entity: NSManagedObject, name: String) {
        var segueIdentifier: String!
        
        switch name {
        case SCConstants.SCENE_DISPLAY_TITLE: return
            
        case SCConstants.SPRITE_DISPLAY_TITLE:
            segueIdentifier = WorldEditorViewController.spritesEditorSegueIdentifier
            break
            
        case SCConstants.GRAPHIC_DISPLAY_TITLE:
            segueIdentifier = WorldEditorViewController.graphicsEditorSegueIdentifier
            break
            
        default: return
        }
        
        self.selectedEntity = entity
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    func deleteEntities(_ entities: [NSManagedObject], name: String) {
        switch name {
        case SCConstants.SCENE_DISPLAY_TITLE:
            break
            
        case SCConstants.SPRITE_DISPLAY_TITLE:
            break
            
        case SCConstants.GRAPHIC_DISPLAY_TITLE:
            break
            
        default: break
        }
    }
    
}