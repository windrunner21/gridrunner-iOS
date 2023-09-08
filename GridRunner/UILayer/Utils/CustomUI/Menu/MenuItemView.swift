//
//  MenuItemView.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 30.05.23.
//

import UIKit

class MenuItemView: UIView {
    // Closure for on play now button click.
    var playNowButtonAction: (() -> Void)?
    
    // Storyboard related properties.
    private let iconLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Kanit-Semibold", size: Dimensions.headingFont)
        label.numberOfLines = 2
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "Gray")
        label.font = UIFont(name: "Kanit-Regular", size: Dimensions.subHeadingFont)
        label.numberOfLines = 3
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let button: PrimaryButton = PrimaryButton()
    
    // Computed properties.
    var icon: String? {
        get {
            return self.iconLabel.text
        }
        set {
            self.iconLabel.text = newValue
        }
    }
    
    var title: String? {
        get {
            return self.titleLabel.text
        }
        set {
            self.titleLabel.text = newValue
        }
    }
    
    var descriptionText: String? {
        get {
            return self.descriptionLabel.text
        }
        set {
            self.descriptionLabel.text = newValue
        }
    }
    
    var image: UIImage? {
        get {
            return self.imageView.image
        }
        set {
            self.imageView.image = newValue
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
    
    private let size: CGFloat = Dimensions.menuItemViewHeight
    
    private let spacing: CGFloat = Dimensions.verticalSpacing20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.button.addTarget(self, action: #selector(onPlay), for: .touchUpInside)
        self.button.setup(in: self, withTitle: "Play now")
        
        self.addSubview(iconLabel)
        self.addSubview(titleLabel)
        self.addSubview(descriptionLabel)
        
        self.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40),
            self.heightAnchor.constraint(equalToConstant: size),
            
            self.iconLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: spacing),
            self.iconLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            self.titleLabel.topAnchor.constraint(equalTo: self.iconLabel.bottomAnchor, constant: spacing),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -20),
            
            self.descriptionLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor),
            self.descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.descriptionLabel.trailingAnchor.constraint(equalTo: self.centerXAnchor, constant: -20),
            
            self.button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -spacing),

            self.imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: spacing),
            self.imageView.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: 20),
            self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -spacing),
        ])
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
    }
    
    func decorateMenuItem(icon: String, title: String, description: String, image: String? = nil) {
        self.icon = icon
        self.title = title
        self.descriptionText = description
        if let image = image { self.image = UIImage(named: image) }
    }
    
    func shouldBeEnabled(if enabled: Bool, iconAndDescription: (icon: String, description: String), else iconAndDescriptionDisabled: (icon: String, description: String)) {
        if enabled {
            self.alpha = 1
            self.icon = iconAndDescription.icon
            self.descriptionText = iconAndDescription.description
        } else {
            self.alpha = 0.3
            self.icon = iconAndDescriptionDisabled.icon
            self.descriptionText = iconAndDescriptionDisabled.description
        }

        self.button.shouldBeEnabled(if: enabled)
    }
    
    @objc func onPlay(_ sender: Any) {
        self.playNowButtonAction?()
    }
}
