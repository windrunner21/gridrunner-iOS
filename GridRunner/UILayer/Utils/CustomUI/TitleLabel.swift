//
//  TitleLabel.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 04.09.23.
//

import UIKit

class TitleLabel: UILabel {
    func setup(in parentView: UIView, as text: String) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.text = text
        self.textColor = UIColor(named: "Black")
        self.font = UIFont(name: "Kanit-Semibold", size: Dimensions.titleFont)
        
        parentView.addSubview(self)
    }
}
