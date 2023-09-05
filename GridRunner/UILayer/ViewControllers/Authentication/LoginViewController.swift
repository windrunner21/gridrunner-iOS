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
    
    // Programmable UI properties.
    let cancelView: CancelView = CancelView()
    let viewTitle: TitleLabel = TitleLabel()
    let viewSubtitle: SubtitleLabel = SubtitleLabel()

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = Dimensions.verticalSpacing20
        return stackView
    }()
    
    let signUpStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    let signUpPromptLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "don't have an account?"
        label.font = UIFont(name: "Kanit-Regular", size: Dimensions.subHeadingFont)
        label.textColor = UIColor(named: "Gray")
        return label
    }()
    
    let signUpLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "sign up"
        label.font = UIFont(name: "Kanit-Regular", size: Dimensions.subHeadingFont)
        label.textColor = UIColor(named: "Red")
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let forgotPasswordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Forgot password?"
        label.font = UIFont(name: "Kanit-Regular", size: Dimensions.buttonFont)
        label.textColor = UIColor(named: "Red")
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let usernameTextFieldView: TextFieldView = TextFieldView()
    let passwordTextFieldView: TextFieldView = TextFieldView()
    
    let signInButton: PrimaryButton = PrimaryButton()
    
    var signInButtonBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: "Background")

        self.cancelView.setup(in: self.view)
        self.setupViewLabels()
        self.setupSignUpLabels()
        self.setupSignInButton()
        self.setupScrollView()
        self.setupTextFieldViews()
        
        // Close current view, dismiss with animation, on cancel view tap.
        let cancelViewTap = UITapGestureRecognizer(target: self, action: #selector(closeView))
        self.cancelView.addGestureRecognizer(cancelViewTap)
        
        // Close keyboard on external tap.
        let externalKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(externalKeyboardTap)
        
        let signUpTap = UITapGestureRecognizer(target: self, action: #selector(onSignUp))
        self.signUpLabel.addGestureRecognizer(signUpTap)
        
        let forgotPasswordTap = UITapGestureRecognizer(target: self, action: #selector(onForgotPassword))
        self.forgotPasswordLabel.addGestureRecognizer(forgotPasswordTap)
        
        // On keyboard show and hide notification move UI elements.
        self.configureKeyboardNotifications()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTextFieldView.textField:
            usernameTextFieldView.textField.resignFirstResponder()
            passwordTextFieldView.textField.becomeFirstResponder()
        case passwordTextFieldView.textField:
            passwordTextFieldView.textField.resignFirstResponder()
            self.sendLoginRequest()
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
    
    @objc func closeView() {
        self.mainViewController.dismiss(animated: true)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
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
        if usernameTextFieldView.textField.isEditing || passwordTextFieldView.textField.isEditing {
            moveWithKeyboard(on: notification, by: -10, this: signInButtonBottomConstraint, up: true)
        }
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        moveWithKeyboard(on: notification, by:  -Dimensions.verticalSpacing20 - self.signUpStackView.frame.height - 10, this: signInButtonBottomConstraint, up: false)
    }
    
    
    @objc func onSignInTouchDown() {
        self.signInButton.onTouchDown()
    }
    
    
    @objc func onSignInTouchUpOutside() {
        self.signInButton.onTouchUpOutside()
    }
    
    @objc func onSignIn() {
        self.sendLoginRequest()
    }
    
    @objc func onSignUp() {
        self.dismiss(animated: true)
    }
    
    @objc func onForgotPassword() {
        let passwordViewController: PasswordViewController = PasswordViewController()
        passwordViewController.mainViewController = self.mainViewController
        self.present(passwordViewController, animated: true)
    }
    
    private func sendLoginRequest() {
        // Hide keyboard if open.
        self.view.endEditing(true)
        
        self.signInButton.disable()
        
        guard let username = usernameTextFieldView.textField.text, let password = passwordTextFieldView.textField.text else {
            self.signInButton.enable()
            return
        }
        
        let credentials = LoginCredentials(username: username, password: password)
        
        AuthService().login(with: credentials) { response in
            DispatchQueue.main.async {
                self.signInButton.enable()
                
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
    
    private func setupViewLabels() {
        self.viewTitle.setup(in: self.view, as: "Hey, welcome back 👋")
        self.viewSubtitle.setup(in: self.view, as: "you have been missed! jump right in and continue from where you have left")
        
        NSLayoutConstraint.activate([
            self.viewTitle.topAnchor.constraint(equalTo: self.cancelView.bottomAnchor, constant: Dimensions.verticalSpacing20),
            self.viewTitle.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.viewTitle.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            self.viewSubtitle.topAnchor.constraint(equalTo: self.viewTitle.bottomAnchor),
            self.viewSubtitle.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.viewSubtitle.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    private func setupScrollView() {
        self.view.addSubview(self.scrollView)
        
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.viewSubtitle.bottomAnchor, constant: Dimensions.verticalSpacing20 * 1.5),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.signInButton.topAnchor, constant: -Dimensions.verticalSpacing20)
        ])
        
        self.scrollView.addSubview(self.stackView)
        
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: Dimensions.verticalSpacing20),
            self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20),
            self.stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -20),
            self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -Dimensions.verticalSpacing20),
            self.stackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40)
        ])
        
        self.stackView.addArrangedSubview(self.usernameTextFieldView)
        self.stackView.addArrangedSubview(self.passwordTextFieldView)
        self.stackView.addArrangedSubview(self.forgotPasswordLabel)
    }
    
    private func setupTextFieldViews() {
        self.usernameTextFieldView.text = "Username"
        self.usernameTextFieldView.textField.delegate = self
        self.usernameTextFieldView.textField.keyboardType = .namePhonePad
        self.usernameTextFieldView.textField.textContentType = .username
        self.usernameTextFieldView.textField.returnKeyType = .continue
        self.usernameTextFieldView.textField.setup(with: "Enter your username")
        
        self.passwordTextFieldView.text = "Password"
        self.passwordTextFieldView.textField.delegate = self
        self.passwordTextFieldView.textField.keyboardType = .default
        self.passwordTextFieldView.textField.textContentType = .password
        self.passwordTextFieldView.textField.returnKeyType = .done
        self.passwordTextFieldView.textField.isSecureTextEntry = true
        self.passwordTextFieldView.textField.setup(with: "Enter your password")
    }
    
    private func setupSignInButton() {
        self.signInButton.addTarget(self, action: #selector(onSignIn), for: .touchUpInside)
        self.signInButton.addTarget(self, action: #selector(onSignInTouchUpOutside), for: .touchUpOutside)
        self.signInButton.addTarget(self, action: #selector(onSignInTouchDown), for: .touchDown)
        
        self.signInButton.width = UIScreen.main.bounds.width - 40
        self.signInButton.height = self.signInButton.width / 8
        self.signInButton.setup(in: self.view, withTitle: "Sign in")
        
        // Update frame to set correct sign in button bottom constraint.
        self.view.layoutIfNeeded()
        
        self.signInButtonBottomConstraint = self.signInButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -Dimensions.verticalSpacing20 - self.signUpStackView.frame.height - 10)
        
        NSLayoutConstraint.activate([
            self.signInButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.signInButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.signInButtonBottomConstraint
        ])
    }
    
    private func setupSignUpLabels() {
        self.view.addSubview(signUpStackView)

        self.signUpStackView.addArrangedSubview(signUpPromptLabel)
        self.signUpStackView.addArrangedSubview(signUpLabel)
        
        NSLayoutConstraint.activate([
            self.signUpStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.signUpStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
}
