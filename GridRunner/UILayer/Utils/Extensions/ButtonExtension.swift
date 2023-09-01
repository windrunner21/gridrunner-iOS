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
    
    func onTouchDown() {
        self.alpha = 0.5
    }
    
    func onTouchUpOutside() {
        self.alpha = 1
    }
    
    func disable() {
        self.alpha = 0.5
        self.isEnabled = false
    }
    
    func enable() {
        self.alpha = 1
        self.isEnabled = true
    }
    
    func shouldBeEnabled(if enabled: Bool) {
        if enabled {
            self.enable()
        } else {
            self.disable()
        }
    }
}
