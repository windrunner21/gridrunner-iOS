//
//  LoadingOverlayView.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 07.09.23.
//

import UIKit

class LoadingOverlayView: UIView {
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = UIColor(named: "Black")?.withAlphaComponent(0.5)
        self.frame = UIScreen.main.bounds
        self.setupActivityIndicator()
    }
    
    private func setupActivityIndicator() {
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        activityIndicator.center = self.center
        self.addSubview(activityIndicator)
        activityIndicator.isHidden = true
    }
    
    func load() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
}
