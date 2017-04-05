//
//  SpritesEditorViewController.swift
//  Make
//
//  Created by Richmond Starbuck on 1/19/17.
//
//

import UIKit
import CoreData


protocol SpritesParametersDelegate {
    
    var spriteGraphic: SCGraphic? { get set }
    
    func selectGraphics()
    func selectPhysics()
    
}


private let physicsViewPageKey = "physics"
private let graphicsViewPageKey = "graphics"

private let pageCornerRadius = CGFloat(15)


class SpritesEditorViewController: UIViewController {
    static let graphicEditorSegueIdentifier = "GraphicsEditorViewControllerSegue"
    
    @IBOutlet weak var parametersView: SpritesParametersView!
    @IBOutlet weak var contentPageView: PageView!
    
    var connector: SCConnector!
    var sprite: SCSprite!
    
    var physicsController: PhysicsDelegate!
    var graphicsSelectionController: SelectionController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setName(self.sprite.name)
        self.edgesForExtendedLayout = UIRectEdge()
        self.view.layoutSubviews()
        
        self.parametersView.delegate = self
        self.parametersView.nameTextField.listeners.insert(self)
        self.parametersView.nameTextField.entity = self.sprite
        
        self.contentPageView.layer.cornerRadius = pageCornerRadius
        self.contentPageView.layer.masksToBounds = true
        self.contentPageView.borderColor = UIColor.lightGray
        self.contentPageView.borderWidth = 0.5
        
        let physicsView = PhysicsView()
        self.physicsController = PhysicsController(view: physicsView, sprite: self.sprite)
        self.contentPageView.addPage(physicsView, key: physicsViewPageKey)
        
        let graphicsSelectionView = SelectionView()
        self.graphicsSelectionController = SelectionController(dataSource: self,
                                                               view: graphicsSelectionView,
                                                               name: SCConstants.GRAPHIC_DISPLAY_TITLE,
                                                               observer: self.sprite.world.graphicObserver)
        
        self.graphicsSelectionController.getImage = { entity in
            let graphic = entity as! SCGraphic
            return graphic.firstFrame.makeImageFromLayers()
        }
        
        self.graphicsSelectionController.getLabel = { entity in
            let graphic = entity as! SCGraphic
            return graphic.name
        }
        
        self.contentPageView.addPage(graphicsSelectionView, key: graphicsViewPageKey)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.parametersView.configure()
        self.physicsController.configure()
        self.graphicsSelectionController.view?.collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SpritesEditorViewController.graphicEditorSegueIdentifier {
            let graphicsEditor = segue.destination as! GraphicsEditorViewController
            graphicsEditor.connector = self.connector
            graphicsEditor.graphic = self.sprite.graphic
        }
    }
    
}

extension SpritesEditorViewController: NameTextFieldListener {
    
    func setName(_ name: String) {
        self.title = "\(SCConstants.SPRITE_DISPLAY_TITLE): \"\(name)\""
    }
    
}

extension SpritesEditorViewController: SpritesParametersDelegate {
    
    var spriteGraphic: SCGraphic? {
        get {
            return self.sprite.graphic
        }
        set {
            self.sprite.graphic = newValue
            self.physicsController.configure()
        }
    }
    
    func selectGraphics() {
        self.contentPageView.showPage(graphicsViewPageKey)
    }
    
    func selectPhysics() {
        self.contentPageView.showPage(physicsViewPageKey)
    }
    
}

extension SpritesEditorViewController: SelectionDataSource {
    
    func createEntity(name: String) {
        if name == SCConstants.GRAPHIC_DISPLAY_TITLE {
            let graphic = self.sprite.world.createGraphic()
            self.didSelectEntity(graphic, name: name)
        }
    }
    
    func didSelectEntity(_ entity: NSManagedObject, name: String) {
        if name == SCConstants.GRAPHIC_DISPLAY_TITLE {
            self.spriteGraphic = entity as? SCGraphic
            self.performSegue(withIdentifier: SpritesEditorViewController.graphicEditorSegueIdentifier, sender: self)
        }
    }
    
    func deleteEntities(_ entities: [NSManagedObject], name: String) {
        if name == SCConstants.GRAPHIC_DISPLAY_TITLE {
            
        }
    }
    
}
