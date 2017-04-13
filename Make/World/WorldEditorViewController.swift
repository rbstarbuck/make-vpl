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
private let spritesEditorSegueIdentifier = "SpritesEditorViewControllerSegue"
private let graphicsEditorSegueIdentifier = "GraphicsEditorViewControllerSegue"
private let gameplaySegueIdentifier = "GameplayViewControllerSegue"

private let selectedArrowColor = UIColor(hex: 0x3366ff)
private let unselectedArrowColor = UIColor.lightGray


class WorldEditorViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: NameTextField!
    @IBOutlet weak var scenesBar: UIView!
    @IBOutlet weak var spritesBar: UIView!
    @IBOutlet weak var graphicsBar: UIView!
    
    @IBOutlet weak var contentPageView: PageView!
    
    var connector: SCConnector!
    var world: SCWorld!
    
    var sceneSelectionView: SelectionView!
    var spriteSelectionView: SelectionView!
    var graphicSelectionView: SelectionView!
    
    var sceneSelectionController: SelectionController!
    var spriteSelectionController: SelectionController!
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
        // end test code
        self.setName(self.world.name)
        self.edgesForExtendedLayout = UIRectEdge()
        self.view.layoutSubviews()
        
        self.nameTextField.listeners.insert(self)
        self.nameTextField.entity = self.world
        
        let playButton = UIButton(type: .custom)
        playButton.setImage(UIImage(named: "Play"), for: .normal)
        playButton.setTitle("Play!", for: .normal)
        playButton.setTitleColor(self.navigationController?.navigationBar.tintColor, for: .normal)
        playButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        playButton.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        playButton.addTarget(self, action: #selector(self.playInitialScene), for: .touchUpInside)
        let playBarButton = UIBarButtonItem(customView: playButton)
//        let playBarButton = UIBarButtonItem(image: UIImage(named: "Play"), style: .plain,
//                                            target: self, action: #selector(self.playInitialScene))
        
        self.navigationItem.rightBarButtonItems = [playBarButton]
        
        self.graphicSelectionView = SelectionView()
        self.graphicSelectionController = SelectionController(dataSource: self,
                                                               view: self.graphicSelectionView,
                                                               name: SCConstants.GRAPHIC_DISPLAY_TITLE,
                                                               observer: self.world.graphicObserver)
        self.contentPageView.addPage(self.graphicSelectionView, key: SCConstants.GRAPHIC_DISPLAY_TITLE)
        
        self.spriteSelectionView = SelectionView()
        self.spriteSelectionController = SelectionController(dataSource: self,
                                                               view: self.spriteSelectionView,
                                                               name: SCConstants.SPRITE_DISPLAY_TITLE,
                                                               observer: self.world.spriteObserver)
        self.contentPageView.addPage(self.spriteSelectionView, key: SCConstants.SPRITE_DISPLAY_TITLE)
        
        self.sceneSelectionView = SelectionView()
        self.sceneSelectionController = SelectionController(dataSource: self,
                                                            view: self.sceneSelectionView,
                                                            name: SCConstants.SCENE_DISPLAY_TITLE,
                                                            observer: self.world.sceneObserver)
        self.sceneSelectionController.cellLength = 3
        self.contentPageView.addPage(self.sceneSelectionView, key: SCConstants.SCENE_DISPLAY_TITLE)
        
        let scenesTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.navigateToScenesPage))
        self.scenesBar.addGestureRecognizer(scenesTapGesture)
        
        let spritesTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.navigateToSpritesPage))
        self.spritesBar.addGestureRecognizer(spritesTapGesture)
        
        let graphicsTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.navigateToGraphicsPage))
        self.graphicsBar.addGestureRecognizer(graphicsTapGesture)
        
        self.navigateToScenesPage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sceneSelectionView.collectionView.reloadData()
        self.spriteSelectionView.collectionView.reloadData()
        self.graphicSelectionView.collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.world.connector.saveContext()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == scenesEditorSegueIdentifier {
            let scenesEditor = segue.destination as! ScenesEditorViewController
            scenesEditor.connector = self.connector
            scenesEditor.scene = self.selectedEntity as! SCScene
        }
        else if segue.identifier == spritesEditorSegueIdentifier {
            let spritesEditor = segue.destination as! SpritesEditorViewController
            spritesEditor.connector = self.connector
            spritesEditor.sprite = self.selectedEntity as! SCSprite
        }
        else if segue.identifier == graphicsEditorSegueIdentifier {
            let graphicsEditor = segue.destination as! GraphicsEditorViewController
            graphicsEditor.connector = self.connector
            graphicsEditor.graphic = self.selectedEntity as! SCGraphic
        }
        else if segue.identifier == gameplaySegueIdentifier {
            let gameplay = segue.destination as! GameplayViewController
            gameplay.connector = self.connector
            gameplay.world = OCWorld(from: self.world, viewSize: self.view.bounds.size)
        }
    }
    
    func navigateToScenesPage() {
        self.scenesBar.tintColor = selectedArrowColor
        self.spritesBar.tintColor = unselectedArrowColor
        self.graphicsBar.tintColor = unselectedArrowColor
        self.contentPageView.showPage(SCConstants.SCENE_DISPLAY_TITLE)
    }
    
    func navigateToSpritesPage() {
        self.scenesBar.tintColor = unselectedArrowColor
        self.spritesBar.tintColor = selectedArrowColor
        self.graphicsBar.tintColor = unselectedArrowColor
        self.contentPageView.showPage(SCConstants.SPRITE_DISPLAY_TITLE)
    }
    
    func navigateToGraphicsPage() {
        self.scenesBar.tintColor = unselectedArrowColor
        self.spritesBar.tintColor = unselectedArrowColor
        self.graphicsBar.tintColor = selectedArrowColor
        self.contentPageView.showPage(SCConstants.GRAPHIC_DISPLAY_TITLE)
    }
    
    func playInitialScene() {
        self.performSegue(withIdentifier: gameplaySegueIdentifier, sender: self)
    }

}


extension WorldEditorViewController: SelectionDataSource {
    
    func createEntity(name: String) {
        var entity: NSManagedObject!
        switch name {
        case SCConstants.SCENE_DISPLAY_TITLE:
            entity = self.world.createScene()
            break
            
        case SCConstants.SPRITE_DISPLAY_TITLE:
            entity = self.world.createSprite()
            break
            
        default:
            entity = self.world.createGraphic()
            break
        }
        self.didSelectEntity(entity, name: name)
    }
    
    func didSelectEntity(_ entity: NSManagedObject, name: String) {
        var identifier: String!
        switch name {
        case SCConstants.SCENE_DISPLAY_TITLE:
            identifier = scenesEditorSegueIdentifier
            break
            
        case SCConstants.SPRITE_DISPLAY_TITLE:
            identifier = spritesEditorSegueIdentifier
            break
            
        default:
            identifier = graphicsEditorSegueIdentifier
            break
        }
        self.selectedEntity = entity
        self.performSegue(withIdentifier: identifier, sender: self)
    }
    
    func getImage(for entity: NSManagedObject, name: String) -> UIImage? {
        switch name {
        case SCConstants.SCENE_DISPLAY_TITLE:
            let scene = entity as! SCScene
            return scene.thumbnail
            
        case SCConstants.SPRITE_DISPLAY_TITLE:
            let sprite = entity as! SCSprite
            return sprite.editorImage
            
        default:
            let graphic = entity as! SCGraphic
            return graphic.firstFrame.makeImageFromLayers()
        }
    }
    
    func getLabel(for entity: NSManagedObject, name: String) -> String? {
        let namedEntity = entity as! SCNamedEntity
        return namedEntity.name
    }
    
}


extension WorldEditorViewController: NameTextFieldListener {
    
    func setName(_ name: String) {
        self.title = "\(SCConstants.WORLD_DISPLAY_TITLE): \"\(name)\""
    }
    
}
