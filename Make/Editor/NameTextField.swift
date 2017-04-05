//
//  NameTextField.swift
//  Make
//
//  Created by Richmond Starbuck on 4/5/17.
//
//

import UIKit
import Material


protocol NameTextFieldListener: class {
    
    func setName(_ name: String)
    
}


class NameTextField: TextField {
    
    var entity: SCNamedEntity? {
        didSet {
            if let entity = self.entity {
                self.text = entity.name
            }
        }
    }
    
    var listeners = WeakSet<NameTextFieldListener>()
    
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        self.returnKeyType = .done
        self.font = UIFont.systemFont(ofSize: 22.0)
        
        self.addTarget(self, action: #selector(self.editingChanged(_:)), for: .editingChanged)
        self.addTarget(self, action: #selector(self.didEndOnExit(_:)), for: .editingDidEndOnExit)
    }
    
    func editingChanged(_ textField: UITextField) {
        let name = (self.text == nil ? "" : self.text!)
        self.entity?.name = name
        for listener in self.listeners {
            listener.setName(name)
        }
    }
    
    @IBAction func didEndOnExit(_ sender: UIView) {
        sender.resignFirstResponder()
    }
    
}
