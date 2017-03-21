//
//  PhysicsShapeView.swift
//  Make
//
//  Created by Richmond Starbuck on 3/19/17.
//
//

import UIKit


private var imageViewBorderWidth = CGFloat(1.5)
private var imageViewBorderColor = UIColor.lightGray

private var shapeControlIndexes = [PhysicsShape.circle, PhysicsShape.rectangle]


class PhysicsShapeView: UIViewFromNib {
    
    @IBOutlet weak var graphicImageView: UIImageView!
    @IBOutlet weak var outlineView: PhysicsShapeOutlineView!
    
    @IBOutlet weak var shapeControl: UISegmentedControl!
    
    
    var delegate: PhysicsShapeDelegate? {
        didSet {
            if self.delegate !== oldValue {
                self.outlineView.delegate = delegate
                
                if let delegate = self.delegate {
                    let shapeControlIndex = shapeControlIndexes.index(of: delegate.sprite.physicsBody.shape.type)
                    self.shapeControl.selectedSegmentIndex = shapeControlIndex!
                    delegate.setOutlineView()
                }
                
                self.configure()
            }
        }
    }
    
    
    override func awakeFromNib() {
        self.isUserInteractionEnabled = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.onPan(_:)))
        self.outlineView.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.onPinch(_:)))
        self.addGestureRecognizer(pinchGesture)
        
        self.outlineView.backgroundColor = UIColor.clear
        self.configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.delegate?.setOutlineView()
    }
    
    
    func configure() {
        if let delegate = self.delegate {
            if let graphic = delegate.sprite.graphic {
                self.graphicImageView.image = graphic.firstFrame.makeImageFromLayers()
                self.graphicImageView.borderColor = imageViewBorderColor
                self.graphicImageView.borderWidth = imageViewBorderWidth
            }
            else {
                self.graphicImageView.image = UIImage(named: "Placeholder image")
                self.graphicImageView.borderWidth = 0
            }
        }
    }
    
    
    func onPan(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            if sender.minimumNumberOfTouches > 0 {
                self.delegate?.panBegan(sender)
            }
            break
            
        case .changed:
            if sender.minimumNumberOfTouches > 0 {
                self.delegate?.panChanged(sender)
            }
            break
            
        case .possible: break
            
        default:
            self.delegate?.panEnded(sender)
            break
        }
    }
    
    func onPinch(_ sender: UIPinchGestureRecognizer) {
        switch sender.state {
        case .began:
            if sender.numberOfTouches > 1 {
                self.delegate?.pinchBegan(sender)
            }
            break
            
            case .changed:
            if sender.numberOfTouches > 1 {
                self.delegate?.pinchChanged(sender)
            }
            break
            
        case .possible: break
            
        default:
            self.delegate?.pinchEnded(sender)
            break
        }
    }
    
    @IBAction func shapeControlValueChanged(_ sender: Any) {
        let type = shapeControlIndexes[self.shapeControl.selectedSegmentIndex]
        self.delegate?.changeShape(type)
    }
}
