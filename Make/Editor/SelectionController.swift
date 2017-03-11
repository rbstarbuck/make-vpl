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
    
    func createEntity()
    
    func deleteSelected()
    
}


protocol SelectionDataSource: class {
    
    func createEntity(name: String)
    
    func didSelectEntity(_ entity: NSManagedObject, name: String)
    
    func deleteEntities(_ entities: [NSManagedObject], name: String)
    
}


class SelectionController: CoreDataCollectionViewController, SelectionDelegate {
    static let addEntityCellIdentifier = "AddEntityCollectionViewCell"
    
    weak var dataSource: SelectionDataSource?
    weak var view: SelectionView?
    
    var name: String
    var textColor = UIColor.white
    var borderColor = UIColor.gray
    var scrollDirection = UICollectionViewScrollDirection.vertical
    var minimumCellSize = CGFloat(110)
    var cellInsetSize = CGFloat(1.5)
    
    var isSelecting = false {
        didSet {
            self.collectionView.allowsMultipleSelection = self.isSelecting
        }
    }
    
    func applyParameters() {
        self.configureCollectionViewController()
        self.configureCollectionViewLayout()
    }
    
    
    init(dataSource: SelectionDataSource, view: SelectionView, name: String, cellIdentifier: String, observer: ObservableEntity) {
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
            
            let size = (self.scrollDirection == .vertical ? self.collectionView.frame.size.width : self.collectionView.frame.size.height)
            let numCellsWide = max(1.0, floor(size / self.minimumCellSize))
            let cellSize = size / numCellsWide //- (numCellsWide * self.cellInsetSize)
            
            let sectionInsetSize = self.cellInsetSize * numCellsWide
            layout.itemSize = CGSize(width: cellSize, height: cellSize)
            layout.sectionInset = UIEdgeInsets(top: sectionInsetSize, left: sectionInsetSize,
                                               bottom: sectionInsetSize, right: sectionInsetSize)
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
