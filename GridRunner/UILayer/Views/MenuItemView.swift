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
        addSubview(contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.contentView.layer.cornerRadius = 20
        self.playButton.layer.cornerRadius = 10
        
        // Adding elevation/shadow to menu item content view
        self.contentView.layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        self.contentView.layer.shadowOpacity = 0.5
        self.contentView.layer.shadowOffset = .zero
        self.contentView.layer.shadowRadius = 10
    }
    
    func decorateMenuItem(icon: String, title: String, description: String, image: String? = nil) {
        self.playModeIconLabel.text = icon
        self.playModeLabel.text = title
        self.playModeDescriptionLabel.text = description
        guard let image = image else { return }
        self.imageView.image = UIImage(named: image)
    }

    
    @IBAction func onPlay(_ sender: Any) {
        self.playNowButtonAction?()
    }
    
}
