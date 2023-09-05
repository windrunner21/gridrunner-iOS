//
//  JoinRoomViewController.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 17.07.23.
//

import UIKit

class JoinRoomViewController: UIViewController, UITextFieldDelegate {
    
    var mainViewController: MainViewController!
    private let alertAdapter: AlertAdapter = AlertAdapter()
    
    @IBOutlet weak var cancelView: UIView!
    
    @IBOutlet weak var roomCodeTextField: UITextField!
    
    @IBOutlet weak var joinRoomButton: UIButton!
    @IBOutlet weak var createRoomButton: UIButton!
    
    @IBOutlet weak var createRoomButtonBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.joinRoomButton.setup()
        
        self.roomCodeTextField.delegate = self
        //self.roomCodeTextField.setup(with: "Enter your shared room code")
        
        
        // Close current view, dismiss with animation, on cancel view tap.
        let cancelViewTap = UITapGestureRecognizer(target: self, action: #selector(closeView))
        self.cancelView.addGestureRecognizer(cancelViewTap)
                
        // On keyboard show and hide notification move UI elements.
        self.configureKeyboardNotifications()
    }
    
    @objc func closeView() {
        self.mainViewController.dismiss(animated: true)
    }
    
    private func configureKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if roomCodeTextField.isEditing {
            moveWithKeyboard(on: notification, by: 40, this: createRoomButtonBottomConstraint, up: true)
        }
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        moveWithKeyboard(on: notification, by: 40, this: createRoomButtonBottomConstraint, up: false)
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
        textField.layer.borderColor = UIColor(named: "Red")?.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor(named: "Gray")?.withAlphaComponent(0.25).cgColor
    }
    
    @IBAction func onCreateRoom(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func onJoinRoomTouchDown(_ sender: Any) {
        self.joinRoomButton.onTouchDown()
    }
    
    
    @IBAction func onJoinRoomTouchUpOutside(_ sender: Any) {
        self.joinRoomButton.onTouchUpOutside()
    }
    
    @IBAction func onJoinRoom(_ sender: Any) {
        self.joinRoomButton.disable()
        
        
    }
}
