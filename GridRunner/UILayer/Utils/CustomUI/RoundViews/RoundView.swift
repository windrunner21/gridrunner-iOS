//
//  RoundView.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 29.08.23.
//

import UIKit

class RoundView: UIView {
    private var widthConstraint: NSLayoutConstraint!
    private var heighConstraint: NSLayoutConstraint!
    
    var size: CGFloat = Dimensions.roundViewHeight
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    // Computed properties.
    var text: String? {
        get {
            return label.text
        }
        set {
            self.label.text = newValue
        }
    }
    
    var textSize: CGFloat {
        get {
            return label.font.pointSize
        }
        set {
            self.label.font = .systemFont(ofSize: newValue)
        }
    }
    
    var color: UIColor? {
        get {
            return self.backgroundColor
        }
        set {
            self.backgroundColor = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(label)
        
        self.setSizeConstraints()
        self.activateSizeConstraints()
        
        NSLayoutConstraint.activate([
            self.label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
        ])
        
        self.toCircle()
    }
    
    func addBorder(width: CGFloat, color: UIColor?) {
        self.layer.borderColor = color?.cgColor
        self.layer.borderWidth = width
    }
    
    func removeBorder() {
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 0
    }
    
    func setBorderColor(to color: UIColor?) {
        self.layer.borderColor = color?.cgColor
    }
    
    func toCircle() {
        self.layer.cornerRadius = self.size / 2
    }
    
    func activateSizeConstraints() {
        self.widthConstraint.isActive = true
        self.heighConstraint.isActive = true
    }
    
    func deactivateSizeConstraints() {
        self.widthConstraint.isActive = false
        self.heighConstraint.isActive = false
    }
    
    func setSizeConstraints() {
        self.widthConstraint = self.widthAnchor.constraint(equalToConstant: self.size)
        self.heighConstraint = self.heightAnchor.constraint(equalToConstant: self.size)
    }
}
