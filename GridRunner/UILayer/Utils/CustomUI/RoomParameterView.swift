//
//  RoomParameterView.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 08.09.23.
//

import UIKit

class RoomParameterView: UIView {
    private let roleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Kanit-Semibold", size: Dimensions.subtitleFont)
        label.textColor = UIColor(named: "Black")
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        return stackView
    }()
    
    // Computed properties.
    var role: PlayerRole? {
        didSet {
            self.roleLabel.text = self.role?.rawValue.capitalized
        }
    }
    
    var image: UIImage? {
        didSet {
            self.imageView.image = self.image
        }
    }
    
    var imageColor: UIColor? {
        get {
            return imageView.tintColor
        }
        set {
            self.imageView.tintColor = newValue
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
        self.addSubview(self.stackView)
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40),
            self.heightAnchor.constraint(equalToConstant: Dimensions.roomParameterView),
            
            self.stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
        
        self.stackView.addArrangedSubview(roleLabel)
        self.stackView.addArrangedSubview(imageView)
        
        self.layer.cornerRadius = 20
        self.backgroundColor = UIColor(named: "Background")
        self.addButtonElevation()
        self.addBorder(color: UIColor(named: "Gray"), width: 1)
    }
}
