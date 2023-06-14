//
//  LoaderView.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 13.06.23.
//

import UIKit

class LoaderView: UIView {
    
    private let overlayView = UIView()
    
    // Main view to display inside parent UIViewController.
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var gameTypeLabel: UILabel!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("Loader", owner: self)
        self.addSubview(contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.contentView.layer.cornerRadius = 10
        self.contentView.addElevation()
        
        self.cancelButton.layer.cornerRadius = 10
        self.cancelButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        // Manage position in the parent view.
        self.hideOnTop()
        
        // Add overlay to disable user interaction and clearly seperate design wise.
        self.overlayView.backgroundColor = UIColor(named: "FrostBlackColor")?.withAlphaComponent(0.5)
        self.overlayView.frame = UIScreen.main.bounds
        self.overlayView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(overlayView)
    }
    
    
    @IBAction func onCancel(_ sender: Any) {
        self.slideOut()
    }
    
    func setup(with gameType: GameType, and label: String) {
        self.gameTypeLabel.text = gameType.label
        self.actionLabel.text = label
    }
    
    func slideIn() {
        superview?.insertSubview(self.overlayView, belowSubview: self)
        UIView.animate(withDuration: 0.3) {
            self.frame.origin.y = 20
        }
    }
    
    func slideOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.hideOnTop()
            self.overlayView.removeFromSuperview()
        }) { _ in 
            self.removeFromSuperview()

        }
    }
    
    private func hideOnTop() {
        var initialFrame = self.frame
        initialFrame.origin.y = -initialFrame.size.height
        self.frame = initialFrame
    }
}
