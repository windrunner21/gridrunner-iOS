//
//  CounterView.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 11.09.23.
//

import UIKit

class CounterView: UIView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .firstBaseline
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    private let counterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Kanit-Semibold", size: Dimensions.nameFont)
        label.textColor = UIColor(named: "Black")
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Kanit-Regular", size: Dimensions.subHeadingFont)
        label.textColor = UIColor(named: "Black")
        return label
    }()
    
    // Computed properties.
    var counter: String? {
        get {
            return self.counterLabel.text
        }
        set {
            self.counterLabel.text = newValue
        }
    }
    
    var label: String? {
        get {
            return self.titleLabel.text
        }
        set {
            self.titleLabel.text = newValue
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
        
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.topAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        self.stackView.addArrangedSubview(self.counterLabel)
        self.stackView.addArrangedSubview(self.titleLabel)
    }
}
