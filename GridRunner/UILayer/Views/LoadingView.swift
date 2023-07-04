//
//  LoadingView.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 19.06.23.
//

import UIKit

class LoadingView: UIView {
    
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
    }
    
    func remove() {
        self.removeFromSuperview()
    }
}
