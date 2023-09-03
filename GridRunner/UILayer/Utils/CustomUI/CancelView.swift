//
//  CancelView.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 02.09.23.
//


import UIKit

class CancelView: RoundView {    
    func setup(in parentView: UIView) {
        self.text = "⬅️"
        self.color = UIColor(named: "Background")
        
        self.addButtonElevation()
        
        parentView.addSubview(self)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.addButtonElevation()
    }
}

