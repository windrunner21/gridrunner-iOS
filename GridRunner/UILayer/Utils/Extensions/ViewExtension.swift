//
//  ViewExtension.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 01.06.23.
//

import UIKit

extension UIView {
    func addElevation() {
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
    }

    func addButtonElevation() {
        self.layer.shadowColor = self.traitCollection.userInterfaceStyle == .dark ? UIColor.white.cgColor : UIColor.black.withAlphaComponent(0.8).cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 4
    }
    
    func removeElevation() {
        self.layer.shadowOpacity = 0.0
    }
    
    func addLightBorder() {
        self.layer.borderWidth = 0.75
        self.layer.borderColor = UIColor.systemGray5.cgColor
    }
}
