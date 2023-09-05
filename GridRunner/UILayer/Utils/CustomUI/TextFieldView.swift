//
//  TextFieldView.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 05.09.23.
//

import UIKit

class TextFieldView: UIView {
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Kanit-Regular", size: Dimensions.subHeadingFont)
        label.textColor = UIColor(named: "Black")
        return label
    }()
    
    var textField: TextField = TextField()
    
    // Computed properties
    var text: String? {
        get {
            return self.label.text
        }
        set {
            self.label.text = newValue
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
        self.addSubview(label)
        self.addSubview(textField)
        
        NSLayoutConstraint.activate([
            self.label.topAnchor.constraint(equalTo: self.topAnchor),
            self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.label.bottomAnchor.constraint(equalTo: self.textField.topAnchor, constant: -5),
            
            self.textField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.textField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.textField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            self.textField.heightAnchor.constraint(equalToConstant: 45),
            self.textField.heightAnchor.constraint(equalToConstant: 45),
            self.textField.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
}
