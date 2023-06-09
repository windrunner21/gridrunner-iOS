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
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.8).cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 4
    }
    
    func transformToCircle() {
        self.layer.cornerRadius = self.bounds.size.height / 2
    }
    
    func addLightBorder() {
        self.layer.borderWidth = 0.75
        self.layer.borderColor = UIColor.systemGray5.cgColor
    }
}
