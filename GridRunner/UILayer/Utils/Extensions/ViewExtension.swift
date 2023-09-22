//
//  ViewExtension.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 01.06.23.
//

import UIKit

extension UIView {
    func addElevation() {
        self.layer.shadowColor = self.traitCollection.userInterfaceStyle == .dark ? UIColor.white.withAlphaComponent(0.5).cgColor : UIColor.black.withAlphaComponent(0.4).cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
    }

    func addButtonElevation() {
        self.layer.shadowColor = self.traitCollection.userInterfaceStyle == .dark ? UIColor.white.withAlphaComponent(0.7).cgColor : UIColor.black.withAlphaComponent(0.8).cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 4
    }
    
    func removeElevation() {
        self.layer.shadowOpacity = 0.0
    }
    
    func addBorder(color: UIColor?, width: CGFloat) {
        self.layer.borderWidth = width
        self.layer.borderColor = color?.cgColor
    }
    
    func removeAnyBorder() {
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.clear.cgColor
    }
}
