//
//  TextField.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 04.09.23.
//

import UIKit

class TextField: UITextField {
    func setup(with placeholder: String? = nil) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = UIFont(name: "Kanit-Regular", size: Dimensions.buttonFont)
        
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor(named: "Gray")?.withAlphaComponent(0.25).cgColor
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "Enter...",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor(named: "Gray")?.withAlphaComponent(0.5) ?? UIColor.systemGray5
            ]
        )
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
    }
}
