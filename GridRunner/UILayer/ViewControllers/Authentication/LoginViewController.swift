//
//  LoginViewController.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 06.06.23.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var mainViewController: MainViewController!
    var alertAdapter: AlertAdapter = AlertAdapter()
    
    // Storyboard related properties.
    @IBOutlet weak var cancelView: UIView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var signUpButtonBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cancelView.transformToCircle()
        self.cancelView.addButtonElevation()
        
        self.signInButton.setup()
        
        // Manage delegate to override UITextField methods.
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        
        // Close current view, dismiss with animation, on cancel view tap.
        let cancelViewTap = UITapGestureRecognizer(target: self, action: #selector(closeView))
        self.cancelView.addGestureRecognizer(cancelViewTap)
        
        // On keyboard show and hide notification move UI elements.
        self.configureKeyboardNotifications()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTextField:
            usernameTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
            self.sendLoginRequest()
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
        if usernameTextField.isEditing || passwordTextField.isEditing {
            moveWithKeyboard(on: notification, by: 40, this: signUpButtonBottomConstraint, up: true)
        }
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        moveWithKeyboard(on: notification, by: 40, this: signUpButtonBottomConstraint, up: false)
    }
    
    
    @IBAction func onSignInTouchDown(_ sender: Any) {
        self.signInButton.onTouchDown()
    }
    
    
    @IBAction func onSignInTouchUpOutside(_ sender: Any) {
        self.signInButton.onTouchUpOutside()
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        self.sendLoginRequest()
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    private func sendLoginRequest() {
        self.signInButton.disable()
        
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            self.signInButton.enable()
            return
        }
        
        let credentials = LoginCredentials(username: username, password: password)
        
        AuthService().login(with: credentials) { response in
            DispatchQueue.main.async {
                self.signInButton.enable()
                
                switch response {
                case .success:
                    self.mainViewController.dismiss(animated: true)
                    print(User.shared)
                case .networkError:
                    let alert = self.alertAdapter.createNetworkErrorAlert()
                    self.present(alert, animated: true)
                case .requestError:
                    let alert = self.alertAdapter.createServiceRequestErrorAlert()
                    self.present(alert, animated: true)
                case .decoderError:
                    print("to handle")
                }
            }
        }
    }
}
