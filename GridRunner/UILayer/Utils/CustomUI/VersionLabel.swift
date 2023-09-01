//
//  VersionLabel.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 01.09.23.
//


import UIKit

class VersionLabel: UILabel {
    let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
    
    func setup(in parentView: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.text = "Version \(versionNumber ?? "not found")"
        self.textColor = UIColor(named: "Black")
        self.font = UIFont(name: "Kanit-Regular", size: Dimensions.captionFont)
        
        parentView.addSubview(self)
    }
}
