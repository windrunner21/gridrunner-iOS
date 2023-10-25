//
//  RoomParameterView.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 08.09.23.
//

import UIKit

class RoomParameterView: UIView {
    
    var setting: Settable?
    var tapAction: (()->Void)?
    private var settingName: String
    
    private let label: UILabel = {
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
    
    convenience init(setting: Settable) {
        self.init()
        self.setting = setting
        self.settingName = setting.rawValue.capitalized
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        self.settingName = String()
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        self.settingName = String()
        super.init(coder: coder)
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

        self.label.text = self.settingName

        self.stackView.addArrangedSubview(self.label)
        self.stackView.addArrangedSubview(self.imageView)
        
        self.layer.cornerRadius = 20
        self.backgroundColor = UIColor(named: "Background")
        self.addButtonElevation()
        
        self.setTapGestureAction()
    }
    
    private func setTapGestureAction() {
        let runnerRoleTap = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        self.addGestureRecognizer(runnerRoleTap)
    }
    
    @objc private func tapGestureAction() {
        self.tapAction?()
    }
}
