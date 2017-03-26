//
//  SelectionViewController.swift
//  Make
//
//  Created by Richmond Starbuck on 3/8/17.
//
//

import UIKit
import CoreData


protocol SelectionDelegate: class {
    
    var isSelecting: Bool { get set }
    
    var getImage: ((NSManagedObject) -> (UIImage?))? { get }
    var getLabel: ((NSManagedObject) -> (String))? { get }

    var name: String { get set }
    var textColor: UIColor { get set}
    var borderColor: UIColor { get set }
    var scrollDirection: UICollectionViewScrollDirection { get set }
    var cellLength: Int { get set }
    var cellSizeDiff: CGFloat { get set }
    var cellInsetSize: CGFloat { get set }
    
    func applyParameters()
    
    func createEntity()
    func deleteSelected()
    
}


protocol SelectionDataSource: class {
    
    func configureSelectionCell(_ cell: CoreDataCollectionViewCell, name: String)
    func createEntity(name: String)
    func didSelectEntity(_ entity: NSManagedObject, name: String)
    func deleteEntities(_ entities: [NSManagedObject], name: String)
    
}

extension SelectionDataSource {
    
    func configureSelectionCell(_ cell: CoreDataCollectionViewCell, name: String) { }
    func didSelectEntity(_ entity: NSManagedObject, name: String) { }
    func deleteEntities(_ entities: [NSManagedObject], name: String) { }
    
}


class SelectionController: CoreDataCollectionViewController, SelectionDelegate {
    static let addEntityCellIdentifier = "AddEntityCollectionViewCell"
    
    weak var dataSource: SelectionDataSource?
    weak var view: SelectionView?
    
    var name: String
    var textColor = UIColor.black
    var borderColor = UIColor(hex: 0xEFEFF4)
    var scrollDirection = UICollectionViewScrollDirection.vertical
    var cellLength = 4
    var cellSizeDiff = CGFloat(24)
    var cellInsetSize = CGFloat(5)
    
    var isSelecting = false {
        didSet {
            self.collectionView.allowsMultipleSelection = self.isSelecting
        }
    }
    
    var getImage: ((NSManagedObject) -> (UIImage?))? = nil
    var getLabel: ((NSManagedObject) -> (String))? = nil

    func applyParameters() {
        self.configureCollectionViewController()
        self.configureCollectionViewLayout()
    }
    
    
    init(dataSource: SelectionDataSource, view: SelectionView, name: String, observer: ObservableEntity, cellIdentifier: String = SelectionCollectionViewCell.cellIdentifier) {
        self.view = view
        self.dataSource = dataSource
        self.name = name
        
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        let addEntityNib = UINib(nibName: SelectionController.addEntityCellIdentifier, bundle: nil)
        view.collectionView.register(cellNib, forCellWithReuseIdentifier: cellIdentifier)
        view.collectionView.register(addEntityNib, forCellWithReuseIdentifier: SelectionController.addEntityCellIdentifier)
        
        super.init(view: view.collectionView, cellIdentifier: cellIdentifier, observer: observer, populate: false)
        
        observer.addListener(self, populate: false)
        self.view?.delegate = self
    }
    
    
    override func configureCollectionViewController() {
        if let view = self.view {
            view.backgroundColor = self.borderColor
            view.titleLabel.textColor = self.textColor
            view.titleLabel.text = "\(self.name)s"
        }
        
        self.collectionView.backgroundColor = borderColor
    }
    
    override func configureCollectionViewLayout() {
        if let layout = self.layout as? UICollectionViewFlowLayout {
            layout.scrollDirection = self.scrollDirection
            
            let size = (self.scrollDirection == .vertical ? self.view!.bounds.width : self.view!.bounds.height - self.view!.titleLabel.bounds.height) - self.cellInsetSize * 4 - 1
            let cellSize = size / CGFloat(self.cellLength) - self.cellInsetSize * CGFloat(self.cellLength - 1)
            layout.minimumInteritemSpacing = 0
            
            if self.scrollDirection == .vertical {
                layout.itemSize = CGSize(width: cellSize, height: cellSize + self.cellSizeDiff)
            }
            else {
                layout.itemSize = CGSize(width: cellSize - self.cellSizeDiff, height: cellSize)
            }
            
            let borderSize = self.cellInsetSize * 2
            layout.sectionInset = UIEdgeInsets(top: borderSize, left: borderSize,
                                               bottom: borderSize, right: borderSize)
        }
    }
    
    
    
    func createEntity() {
        if !self.isSelecting {
            self.dataSource?.createEntity(name: self.name)
        }
    }
    
    func deleteSelected() {
        if self.isSelecting {
            guard let indexPaths = self.collectionView.indexPathsForSelectedItems else {
                return
            }
            
            if indexPaths.count > 0 {
                var entities = [NSManagedObject]()
                
                for indexPath in indexPaths {
                    if let cell = self.collectionView.cellForItem(at: indexPath) as? CoreDataCollectionViewCell {
                        entities.append(cell.entity)
                    }
                }
                
                if entities.count > 0 {
                    self.dataSource?.deleteEntities(entities, name: self.name)
                }
            }
        }
    }
    
    override func configureCollectionViewCell(_ cell: CoreDataCollectionViewCell) {
        self.dataSource?.configureSelectionCell(cell, name: self.name)
    }
    
}

extension SelectionController {
    
    var itemCount: Int {
        get {
            if let count = self.frc?.fetchedObjects?.count {
                return count
            }
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + super.collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < self.itemCount {
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
        
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: SelectionController.addEntityCellIdentifier, for: indexPath) as! AddEntityCollectionViewCell
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !self.isSelecting {
            if indexPath.row < self.itemCount {
                if let cell = self.collectionView.cellForItem(at: indexPath) as? CoreDataCollectionViewCell {
                    self.dataSource?.didSelectEntity(cell.entity, name: self.name)
                }
            }
        }
        else {
            if indexPath.row == self.itemCount {
                self.dataSource?.createEntity(name: self.name)
            }
            else if let view = self.view {
                if !view.cellsAreSelected {
                    view.cellsAreSelected = true
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if self.isSelecting && indexPath.row < self.itemCount {
            if let itemCount = self.collectionView.indexPathsForSelectedItems?.count {
                if itemCount == 0 {
                    if let view = self.view {
                        if view.cellsAreSelected {
                            view.cellsAreSelected = false
                        }
                    }
                }
            }
        }
    }
    
}
