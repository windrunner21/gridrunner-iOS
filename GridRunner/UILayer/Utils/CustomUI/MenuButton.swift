//
//  MenuButton.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 31.08.23.
//

import UIKit

class MenuButton: UIView {
    var menuAction: (() -> Void)?
    
    private let iconLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont(name: "Kanit-Semibold", size: Dimensions.subtitleFont)
        label.numberOfLines = 2
        return label
    }()
    
    // Computed properties.
    var text: String? {
        get {
            return self.titleLabel.text
        }
        set {
            self.titleLabel.text = newValue
        }
    }

    var icon: String? {
        get {
            return self.iconLabel.text
        }
        set {
            self.iconLabel.text = newValue
        }
    }
    
    private let size: CGFloat = Dimensions.buttonWidth
    
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
        
        self.addSubview(iconLabel)
        self.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            self.iconLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.iconLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            
            self.widthAnchor.constraint(equalToConstant: self.size),
            self.heightAnchor.constraint(equalToConstant: self.size * 1.5)
        ])
        
        self.layer.cornerRadius = 10
        self.backgroundColor = .white
        self.addButtonElevation()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(performAction))
        self.addGestureRecognizer(tap)
    }
    
    @objc func performAction() {
        self.menuAction?()
    }
}
