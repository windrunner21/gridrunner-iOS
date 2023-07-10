//
//  PasswordViewController.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 10.07.23.
//

import UIKit

class PasswordViewController: UIViewController, UITextFieldDelegate {
    
    var mainViewController: MainViewController!
    var alertAdapter: AlertAdapter = AlertAdapter()

    // Storyboard related properties.
    @IBOutlet weak var cancelView: UIView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var resetPasswordButtonBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cancelView.transformToCircle()
        self.cancelView.addElevation()
        
        self.resetPasswordButton.setup()
        
        // Manage delegate to override UITextField methods.
        self.emailTextField.delegate = self
        
        let cancelViewTap = UITapGestureRecognizer(target: self, action: #selector(closeView))
        
        self.cancelView.addGestureRecognizer(cancelViewTap)
        
        // On keyboard show and hide notification move UI elements.
        self.configureKeyboardNotifications()
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            emailTextField.resignFirstResponder()
            self.sendResetPasswordRequest()
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
        textField.layer.borderWidth = 0
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
        if emailTextField.isEditing {
            moveWithKeyboard(on: notification, by: 40, this: resetPasswordButtonBottomConstraint, up: true)
        }
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        moveWithKeyboard(on: notification, by: 40, this: resetPasswordButtonBottomConstraint, up: false)
    }
    
    
    @IBAction func onResetPasswordTouchDown(_ sender: Any) {
        self.resetPasswordButton.onTouchDown()
    }
    
    @IBAction func onResetPasswordTouchUpOutside(_ sender: Any) {
        self.resetPasswordButton.onTouchUpOutside()
    }
    
    @IBAction func onResetPassword(_ sender: Any) {
        self.sendResetPasswordRequest()
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    private func sendResetPasswordRequest() {
        self.resetPasswordButton.disable()
        
        guard let email = emailTextField.text else {
            self.resetPasswordButton.enable()
            return
        }
        
        PasswordService().resetPassword(for: email) {
            response in
            DispatchQueue.main.async {
                self.resetPasswordButton.enable()
                
                switch response {
                case .success:
                    let alert = self.alertAdapter.createCheckEmailAlert()
                    self.present(alert, animated: true)
                case .networkError:
                    let alert = self.alertAdapter.createNetworkErrorAlert()
                    self.present(alert, animated: true)
                case .requestError:
                    let alert = self.alertAdapter.createServiceRequestErrorAlert()
                    self.present(alert, animated: true)
                case .decoderError:
                    let alert = self.alertAdapter.createDecoderErrorAlert()
                    self.present(alert, animated: true)
                }
            }
        }
    }
}
