//
//  LoadingView.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 19.06.23.
//

import UIKit

class LoadingView: UIView {
    

    private let overlayView = UIView()
    
    @IBOutlet var contentView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("Loading", owner: self)
        self.addSubview(contentView)
        
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Add overlay to disable user interaction and clearly seperate design wise.
        self.overlayView.backgroundColor = UIColor(named: "FrostBlackColor")?.withAlphaComponent(0.5)
        self.overlayView.frame = UIScreen.main.bounds
        self.overlayView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(overlayView)
    }
    
    func remove() {
        self.overlayView.removeFromSuperview()
        self.removeFromSuperview()
    }
}
