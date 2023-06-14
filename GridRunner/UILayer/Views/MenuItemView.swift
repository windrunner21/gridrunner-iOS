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

    // Main view to display inside parent UIViewController.
    @IBOutlet var contentView: UIView!
    
    // Storyboard related properties.
    @IBOutlet weak var playModeIconLabel: UILabel!
    @IBOutlet weak var playModeLabel: UILabel!
    @IBOutlet weak var playModeDescriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var playButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("MenuItem", owner: self)
        self.addSubview(contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.contentView.layer.cornerRadius = 20
        self.playButton.setup()
        
        self.playButton.setTitle("Play now", for: .normal)
        self.playButton.setTitle("Locked", for: .disabled)
        
        self.contentView.addElevation()
    }
    
    func decorateMenuItem(icon: String, title: String, description: String, image: String? = nil) {
        self.playModeIconLabel.text = icon
        self.playModeLabel.text = title
        self.playModeDescriptionLabel.text = description
        guard let image = image else { return }
        self.imageView.image = UIImage(named: image)
    }
    
    func shouldBeEnabled(if enabled: Bool, iconAndDescription: (icon: String, description: String), else iconAndDescriptionDisabled: (icon: String, description: String)) {
        if enabled {
            self.contentView.alpha = 1
            self.playModeIconLabel.text = iconAndDescription.icon
            self.playModeDescriptionLabel.text = iconAndDescription.description
        } else {
            self.contentView.alpha = 0.3
            self.playModeIconLabel.text = iconAndDescriptionDisabled.icon
            self.playModeDescriptionLabel.text = iconAndDescriptionDisabled.description
        }

        self.playButton.shouldBeEnabled(if: enabled)
    }
    
    @IBAction func onPlay(_ sender: Any) {
        self.playNowButtonAction?()
    }
    
}
