//
//  SubtitleLabel.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 04.09.23.
//

import UIKit

class SubtitleLabel: UILabel {
    func setup(in parentView: UIView, as text: String) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.text = text
        self.textColor = UIColor(named: "Gray")
        self.font = UIFont(name: "Kanit-Regular", size: Dimensions.subHeadingFont)
        self.numberOfLines = 4
        
        parentView.addSubview(self)
    }
}
