//
//  GameButtonView.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 11.09.23.
//

import UIKit

class GameButtonView: UIView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    private let buttonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "Gray")
        label.font = UIFont(name: "Kanit-Regular", size: Dimensions.subHeadingFont)
        label.textAlignment = .center
        return label
    }()
    
    private let gameButton: GameButton = GameButton()
    
    // Computed properties.
    var text: String? {
        get {
            return self.buttonLabel.text
        }
        set {
            self.buttonLabel.text = newValue
        }
    }
    
    var image: UIImage? {
        get {
            return self.gameButton.image
        }
        set {
            self.gameButton.image = newValue
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
        
        self.stackView.addArrangedSubview(gameButton)
        self.stackView.addArrangedSubview(buttonLabel)
    }
    
    func enable() {
        self.gameButton.isEnabled = true
    }
    
    func disable() {
        self.gameButton.isEnabled = false
    }
}

class GameButton: UIView {
    var isEnabled: Bool = false
    
    private let buttonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.tintColor = .white
        return imageView
    }()
    
    // Computed properties.
    var image: UIImage? {
        get {
            return buttonImageView.image
        }
        set {
            self.buttonImageView.image = newValue
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
        self.addSubview(buttonImageView)
        
        NSLayoutConstraint.activate([
            self.buttonImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.buttonImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.buttonImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            self.buttonImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
        
        self.backgroundColor = UIColor(named: "Red")
        self.layer.cornerRadius = 40 / 2
        self.addButtonElevation()
    }
}
