//
//  ButtonExtension.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 02.06.23.
//

import UIKit

extension UIButton {
    func setup() {
        self.layer.cornerRadius = 10
    }
    
    func disable() {
        self.isEnabled = false
        self.backgroundColor = UIColor(named: "SecondaryColor")
    }
    
    func enable() {
        self.isEnabled = true
        self.backgroundColor = UIColor(named: "RedAccentColor")
    }
}
