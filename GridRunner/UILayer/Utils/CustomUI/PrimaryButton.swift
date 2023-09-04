//
//  PrimaryButton.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 01.09.23.
//

import UIKit

class PrimaryButton: UIButton {
    var width: CGFloat = Dimensions.buttonWidth
    var height: CGFloat = Dimensions.buttonWidth / 2.5
    let customFont = UIFont(name: "Kanit-Medium", size: Dimensions.buttonFont)
    
    func setup(in parentView: UIView, withTitle title: String) {
        self.translatesAutoresizingMaskIntoConstraints = false

        self.titleLabel?.font = self.customFont
        self.setTitle(title, for: .normal)
        self.backgroundColor = UIColor(named: "Red")
        self.layer.cornerRadius = 10
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: self.width),
            self.heightAnchor.constraint(equalToConstant: self.height)
        ])
        
        parentView.addSubview(self)
    }
}
