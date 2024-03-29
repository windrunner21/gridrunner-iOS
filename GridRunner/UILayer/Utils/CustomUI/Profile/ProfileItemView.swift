//
//  ProfileItemView.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 04.09.23.
//

import UIKit

class ProfileItemView: UIView {
    private let mainStackView: UIStackView = {
        let mainStackView = UIStackView()
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .horizontal
        mainStackView.alignment = .center
        mainStackView.distribution = .fillProportionally
        mainStackView.spacing = 10
        return mainStackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "Black")
        label.font = UIFont(name: "Kanit-Medium", size: Dimensions.buttonFont)
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        return imageView
    }()
    
    var title: String? {
        get {
            return self.titleLabel.text
        }
        set {
            self.titleLabel.text = newValue
        }
    }
    
    var image: String = String() {
        didSet {
            self.imageView.image = UIImage(systemName: self.image)
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
    
    var textColor: UIColor? {
        get {
            return self.titleLabel.textColor
        }
        set {
            self.titleLabel.textColor = newValue
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
        self.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            self.mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            self.mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        ])
        
        mainStackView.addArrangedSubview(imageView)
        mainStackView.addArrangedSubview(titleLabel)

        self.layer.cornerRadius = 10
        self.backgroundColor = .white
        self.addButtonElevation()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.addButtonElevation()
     }
}
