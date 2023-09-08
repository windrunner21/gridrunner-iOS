//
//  ProfileView.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 29.08.23.
//

import UIKit

class ProfileView: RoundView {
    var isButton: Bool = false
    
    func setup(in parentView: UIView) {
        self.text = ProfileIcon.shared.getIcon()
        self.color = UIColor(named: "Profile")
        
        self.addBorder(width: 3.5, color: UIColor(named: "Background") ?? .white)
        if self.isButton {
            self.addButtonElevation()
        } else {
            self.addElevation()
        }
        
        parentView.addSubview(self)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        self.addBorder(width: 3.5, color: UIColor(named: "Background") ?? .white)
        if self.isButton {
            self.addButtonElevation()
        } else {
            self.addElevation()
        }
    }
    
    func setSize(to size: CGFloat) {
        self.deactivateSizeConstraints()
        
        self.size = size
        self.setSizeConstraints()
        self.toCircle()
      
        self.activateSizeConstraints()
    }
}
