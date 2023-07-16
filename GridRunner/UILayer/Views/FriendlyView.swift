//
//  Friendly.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 16.07.23.
//

import UIKit

class FriendlyView: UIView, UITextFieldDelegate {

    private let overlayView = UIView()
    
    // Main view to display inside parent UIViewController.
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var createRoomStackView: UIStackView!
    @IBOutlet weak var joinRoomStackView: UIStackView!
    
    @IBOutlet weak var rolePopUpButton: UIButton!
    @IBOutlet weak var roomCodeTextField: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var hintLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("Friendly", owner: self)
        self.addSubview(contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.contentView.layer.cornerRadius = 10
        self.contentView.addElevation()
        
        self.setupRolePopUpButton()
        self.cancelButton.setup()
        self.doneButton.setup()
        
        self.hintLabel.text = String()
        
        self.roomCodeTextField.delegate = self
        self.roomCodeTextField.setup(with: "Enter shared room code")
        
        // Manage position in the parent view.
        self.hideOnTop()
        
        // Add overlay to disable user interaction and clearly seperate design wise.
        self.overlayView.backgroundColor = UIColor(named: "FrostBlackColor")?.withAlphaComponent(0.5)
        self.overlayView.frame = UIScreen.main.bounds
        self.overlayView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(overlayView)
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
    
    private func setupRolePopUpButton() {
        rolePopUpButton.menu = UIMenu(
            children: [
                UIAction(
                    title: "Runner", handler: { _ in
                        self.hintLabel.text = "⚠️ You are now creating new room"
                        self.doneButton.setTitle("Create room", for: .normal)
                    }
                ),
                UIAction(
                    title: "Seeker", handler: { _ in
                        self.hintLabel.text = "⚠️ You are now creating new room"
                        self.doneButton.setTitle("Create room", for: .normal)
                    }
                ),
                UIAction(
                    title: "Random", handler: { _ in
                        self.hintLabel.text = "⚠️ You are now creating new room"
                        self.doneButton.setTitle("Create room", for: .normal)
                    }
                )
            ]
        )
        
        rolePopUpButton.showsMenuAsPrimaryAction = true
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.slideOut()
    }
    
    @IBAction func onDone(_ sender: Any) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case roomCodeTextField:
            roomCodeTextField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.cornerRadius = 6
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(named: "RedAccentColor")?.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor(named: "SecondaryColor")?.withAlphaComponent(0.25).cgColor
        
        self.hintLabel.text = "⚠️ You are now joining room"
        self.doneButton.setTitle("Join room", for: .normal)
    }
}
