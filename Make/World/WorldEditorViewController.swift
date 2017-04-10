//
//  WorldEditorViewController.swift
//  Make
//
//  Created by Richmond Starbuck on 2/26/17.
//
//

import UIKit
import CoreData


private let scenesEditorSegueIdentifier = "ScenesEditorViewControllerSegue"


class WorldEditorViewController: UIViewController {
    
    @IBOutlet weak var sceneSelectionView: SelectionView!
    
    var connector: SCConnector!
    var world: SCWorld!
    
    var sceneSelectionController: SelectionController!
    
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
        // end test code
        
        self.title = "\(SCConstants.WORLD_DISPLAY_TITLE): \"\(self.world.name)\""
        self.edgesForExtendedLayout = UIRectEdge()
        self.view.layoutSubviews()
        
        self.sceneSelectionController = SelectionController(dataSource: self,
                                                            view: self.sceneSelectionView,
                                                            name: SCConstants.SCENE_DISPLAY_TITLE,
                                                            observer: self.world.sceneObserver)
        self.sceneSelectionController.cellLength = 4
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.sceneSelectionView.collectionView.reloadData()
        self.connector.saveContext()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == scenesEditorSegueIdentifier {
            if let scenesEditor = segue.destination as? ScenesEditorViewController {
                scenesEditor.connector = self.connector
                scenesEditor.scene = self.selectedEntity as! SCScene
            }
        }
    }

}


extension WorldEditorViewController: SelectionDataSource {
    
    func createEntity(name: String) {
        let entity = self.world.createScene()
        self.didSelectEntity(entity, name: name)
    }
    
    func didSelectEntity(_ entity: NSManagedObject, name: String) {
        self.selectedEntity = entity
        self.performSegue(withIdentifier: scenesEditorSegueIdentifier, sender: self)
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
    
    func getImage(for entity: NSManagedObject, name: String) -> UIImage? {
        return nil
    }
    
    func getLabel(for entity: NSManagedObject, name: String) -> String? {
        if name == SCConstants.SCENE_DISPLAY_TITLE {
            let scene = entity as! SCScene
            return scene.name
        }
        return nil
    }
    
}
