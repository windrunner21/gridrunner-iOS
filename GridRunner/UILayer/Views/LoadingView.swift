//
//  LoadingView.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 19.06.23.
//

import UIKit

class LoadingView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var roomCodeStackView: UIStackView!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var roomCodeTextField: UITextField!
    
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
        
        self.copyButton.setup()
        
        self.roomCodeTextField.setup()
        self.roomCodeTextField.isEnabled = false
        self.roomCodeTextField.text = GameSessionDetails.shared.roomCode
        
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func remove() {
        self.removeFromSuperview()
    }
    
    @IBAction func onCopyTouchDown(_ sender: Any) {
        self.copyButton.onTouchDown()
    }
    
    @IBAction func onCopyTouchUpOutside(_ sender: Any) {
        self.copyButton.onTouchUpOutside()
    }
    
    @IBAction func onCopy(_ sender: Any) {
        self.copyButton.disable()
        let pasteboard = UIPasteboard.general
        pasteboard.string = roomCodeTextField.text
        self.copyButton.enable()
    }
}
