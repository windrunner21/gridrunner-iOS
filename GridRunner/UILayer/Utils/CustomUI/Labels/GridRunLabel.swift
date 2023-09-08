//
//  GridRunLabel.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 31.08.23.
//

import UIKit

class GridRunLabel: UILabel {
    func setup(in parentView: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.text = "GRIDRUN"
        self.textColor = UIColor(named: "Black")
        self.font = UIFont(name: "Kanit-Black", size: Dimensions.nameFont)
        
        parentView.addSubview(self)
    }
}
