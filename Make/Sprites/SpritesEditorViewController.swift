//
//  SpritesEditorViewController.swift
//  Make
//
//  Created by Richmond Starbuck on 1/19/17.
//
//

import UIKit
import CoreData


private let selectedArrowColor = UIColor(hex: 0x3366ff)
private let unselectedArrowColor = UIColor.lightGray


protocol SpritesParametersDelegate {
    
    var spriteGraphic: SCGraphic? { get set }
    var spritePhysics: SCPhysicsBody { get }
    
    func navigateToGraphicsPage()
    func navigateToPhysicsPage()
    
}


private let graphicEditorSegueIdentifier = "GraphicsEditorViewControllerSegue"

private let physicsViewPageKey = "physics"
private let graphicsViewPageKey = "graphics"


class SpritesEditorViewController: UIViewController {
    
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
        
        self.contentPageView.layer.masksToBounds = true
        
        let physicsView = PhysicsView()
        self.physicsController = PhysicsController(view: physicsView, sprite: self.sprite)
        
        let graphicsSelectionView = SelectionView()
        self.graphicsSelectionController = SelectionController(dataSource: self,
                                                               view: graphicsSelectionView,
                                                               name: SCConstants.GRAPHIC_DISPLAY_TITLE,
                                                               observer: self.sprite.world.graphicObserver)
        
        self.contentPageView.addPage(physicsView, key: physicsViewPageKey)
        self.contentPageView.addPage(graphicsSelectionView, key: graphicsViewPageKey)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configure()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.sprite.world.connector.saveContext()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == graphicEditorSegueIdentifier {
            let graphicsEditor = segue.destination as! GraphicsEditorViewController
            graphicsEditor.connector = self.connector
            graphicsEditor.graphic = self.sprite.graphic
        }
    }
    
    func configure() {
        self.parametersView.configure()
        self.physicsController.configure()
        self.graphicsSelectionController.view?.collectionView.reloadData()
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
    
    var spritePhysics: SCPhysicsBody {
        get {
            return self.sprite.physicsBody
        }
    }
    
    func navigateToGraphicsPage() {
        self.parametersView.graphicArrowImageView.tintColor = selectedArrowColor
        self.parametersView.physicsArrowImageView.tintColor = unselectedArrowColor
        self.contentPageView.showPage(graphicsViewPageKey)
    }
    
    func navigateToPhysicsPage() {
        self.parametersView.graphicArrowImageView.tintColor = unselectedArrowColor
        self.parametersView.physicsArrowImageView.tintColor = selectedArrowColor
        self.contentPageView.showPage(physicsViewPageKey)
    }
    
}

extension SpritesEditorViewController: SelectionDataSource {
    
    func configureSelectionCell(_ cell: CoreDataCollectionViewCell, name: String) {
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.navigateToGraphic(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        cell.addGestureRecognizer(doubleTapGesture)
    }
    
    func navigateToGraphic(_ sender: UIGestureRecognizer) {
        if let coreDataCell = sender.view as? CoreDataCollectionViewCell,
                let graphic = coreDataCell.entity as? SCGraphic {
            self.sprite.graphic = graphic
            self.performSegue(withIdentifier: graphicEditorSegueIdentifier, sender: self)
        }
    }
    
    func createEntity(name: String) {
        if name == SCConstants.GRAPHIC_DISPLAY_TITLE {
            self.spriteGraphic = self.sprite.world.createGraphic()
            self.performSegue(withIdentifier: graphicEditorSegueIdentifier, sender: self)
        }
    }
    
    func didSelectEntity(_ entity: NSManagedObject, name: String) {
        if name == SCConstants.GRAPHIC_DISPLAY_TITLE {
            self.spriteGraphic = entity as? SCGraphic
            self.configure()
        }
    }
    
    func deleteEntities(_ entities: [NSManagedObject], name: String) {
        if name == SCConstants.GRAPHIC_DISPLAY_TITLE {
            
        }
    }
    
    func getImage(for entity: NSManagedObject, name: String) -> UIImage? {
        if name == SCConstants.GRAPHIC_DISPLAY_TITLE {
            let graphic = entity as! SCGraphic
            return graphic.firstFrame.makeImageFromLayers()
        }
        return nil
    }
    
    func getLabel(for entity: NSManagedObject, name: String) -> String? {
        if name == SCConstants.GRAPHIC_DISPLAY_TITLE {
            let graphic = entity as! SCGraphic
            return graphic.name
        }
        return nil
    }
    
}
