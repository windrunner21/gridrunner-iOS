//
//  RoomLoadingView.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 17.07.23.
//

import UIKit

class RoomLoadingView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var cancelView: UIView!
    
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
        Bundle.main.loadNibNamed("RoomLoading", owner: self)
        self.addSubview(contentView)
        
        self.copyButton.setup()
        
        self.cancelView.transformToCircle()
        self.cancelView.addElevation()
        
        self.roomCodeTextField.setup()
        self.roomCodeTextField.isEnabled = false
        self.roomCodeTextField.text = GameSessionDetails.shared.roomCode
        
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Close current view, dismiss with animation, on cancel view tap.
        let cancelViewTap = UITapGestureRecognizer(target: self, action: #selector(closeView))
        self.cancelView.addGestureRecognizer(cancelViewTap)
    }

    @objc func closeView() {
        self.removeFromSuperview()
        AblyService.shared.leaveGame()
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
        let mainViewController: UIViewController = mainStoryboard.instantiateViewController(identifier: "MainScreen") as MainViewController
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.transitionViewController.transition(to: mainViewController, with: [.transitionCurlDown])
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
