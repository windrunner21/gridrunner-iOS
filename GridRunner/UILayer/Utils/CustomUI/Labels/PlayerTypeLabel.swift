//
//  PlayerTypeLabel.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 11.09.23.
//

import UIKit

class PlayerTypeLabel: UILabel {
    func setup(in parentView: UIView, as text: String) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.text = text
        self.textColor = UIColor(named: "Black")
        self.font = UIFont(name: "Kanit-Medium", size: Dimensions.buttonFont)
        
        parentView.addSubview(self)
    }
}
