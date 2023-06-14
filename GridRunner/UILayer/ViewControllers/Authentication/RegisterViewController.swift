//
//  RegisterViewController.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 08.05.23.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {

    var mainViewController: MainViewController!
    var alertAdapter: AlertAdapter = AlertAdapter()
    
    // Storyboard related properties.
    @IBOutlet weak var cancelView: UIView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var signUpButtonBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cancelView.transformToCircle()
        self.cancelView.addButtonElevation()

        self.signUpButton.setup()

        // Manage delegate to override UITextField methods.
        self.usernameTextField.delegate = self
        self.emailTextField.delegate = self
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
            emailTextField.becomeFirstResponder()
        case emailTextField:
            emailTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
            self.sendRegisterRequest()
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
        if usernameTextField.isEditing || emailTextField.isEditing || passwordTextField.isEditing {
            moveWithKeyboard(on: notification, by: 40, this: signUpButtonBottomConstraint, up: true)
        }
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        moveWithKeyboard(on: notification, by: 40, this: signUpButtonBottomConstraint, up: false)
    }
    
    @IBAction func onSignUpTouchDown(_ sender: Any) {
        self.signUpButton.onTouchDown()
    }
    
    @IBAction func onSignUpTouchUpOutside(_ sender: Any) {
        self.signUpButton.onTouchUpOutside()
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        self.sendRegisterRequest()
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        let loginStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: .main)
        let loginViewController: LoginViewController = loginStoryboard.instantiateViewController(identifier: "LoginScreen")
        
        loginViewController.mainViewController = self.mainViewController
        
        self.present(loginViewController, animated: true)
    }
    
    private func sendRegisterRequest() {
        self.signUpButton.disable()
        
        guard let username = usernameTextField.text, let password = passwordTextField.text, let email = emailTextField.text else {
            self.signUpButton.enable()
            return
        }
        
        let credentials = RegisterCredentials(username: username,password: password, email: email)
        AuthService().register(with: credentials) { response in
            DispatchQueue.main.async {
                self.signUpButton.enable()
                
                switch response {
                case .success:
                    self.mainViewController.checkUserAuthentication()
                    self.mainViewController.dismiss(animated: true)
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
