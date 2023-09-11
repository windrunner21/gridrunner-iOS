//
//  UsernameLabel.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 11.09.23.
//

import UIKit

class UsernameLabel: UILabel {
    func setup(in parentView: UIView, as text: String) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.text = text
        self.textColor = UIColor(named: "Gray")
        self.font = UIFont(name: "Kanit-Regular", size: Dimensions.subHeadingFont)
        
        parentView.addSubview(self)
    }
}
