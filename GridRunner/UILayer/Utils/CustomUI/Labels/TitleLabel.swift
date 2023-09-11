//
//  TitleLabel.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 04.09.23.
//

import UIKit

class TitleLabel: UILabel {
    func setup(in parentView: UIView, as text: String) {
        self.text = text
        self.setupInView(parentView)
    }
    
    func setup(in parentView: UIView) {
        self.setupInView(parentView)
    }
    
    private func setupInView(_ view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textColor = UIColor(named: "Black")
        self.font = UIFont(name: "Kanit-Semibold", size: Dimensions.titleFont)
        
        view.addSubview(self)
    }
}
