//
//  ProfileView.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 29.08.23.
//

import UIKit

class ProfileView: RoundView {
    func setup(in parentView: UIView, asButton: Bool) {
        self.text = ProfileIcon.shared.getIcon()
        self.color = UIColor(named: "Profile")
        self.addBorder(width: 3.5, color: .white)
    
        if asButton {
            self.addButtonElevation()
        }
        
        parentView.addSubview(self)
    }
}
