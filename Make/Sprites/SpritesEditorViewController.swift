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
    
    var spriteName: String { get set }
    var spriteComment: String? { get set }
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
    
    var physicsPropertiesController: PhysicsPropertiesDelegate!
    var graphicsSelectionController: SelectionController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(SCConstants.SPRITE_DISPLAY_TITLE): \"\(self.sprite.name)\""
        self.edgesForExtendedLayout = UIRectEdge()
        self.view.layoutSubviews()
        
        self.parametersView.delegate = self
        
        self.contentPageView.layer.cornerRadius = pageCornerRadius
        self.contentPageView.layer.masksToBounds = true
        
        let physicsPropertiesView = PhysicsPropertiesView()
        self.physicsPropertiesController = PhysicsPropertiesController(view: physicsPropertiesView,
                                                                       physicsBody: self.sprite.physicsBody)
        self.contentPageView.addPage(physicsPropertiesView, key: physicsViewPageKey)
        
        let graphicsSelectionView = SelectionView()
        self.graphicsSelectionController = SelectionController(dataSource: self,
                                                               view: graphicsSelectionView,
                                                               name: SCConstants.GRAPHIC_DISPLAY_TITLE,
                                                               cellIdentifier: GraphicSelectionCollectionViewCell.cellIdentifier,
                                                               observer: self.sprite.world.graphicObserver)
        self.graphicsSelectionController.borderColor = UIColor.lightGray
        self.graphicsSelectionController.textColor = UIColor.black
        self.graphicsSelectionController.applyParameters()
        self.contentPageView.addPage(graphicsSelectionView, key: graphicsViewPageKey)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.parametersView.configure()
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

extension SpritesEditorViewController: SpritesParametersDelegate {
    
    var spriteName: String {
        get {
            return self.sprite.name
        }
        set {
            self.sprite.name = newValue
            self.title = "\(SCConstants.SPRITE_DISPLAY_TITLE): \"\(newValue)\""
        }
    }
    
    var spriteComment: String? {
        get {
            return self.sprite.comment
        }
        set {
            self.sprite.comment = newValue
        }
    }
    
    var spriteGraphic: SCGraphic? {
        get {
            return self.sprite.graphic
        }
        set {
            self.sprite.graphic = newValue
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
