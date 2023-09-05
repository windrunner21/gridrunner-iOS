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
    
    let signInStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    let signInPromptLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "have an account?"
        label.font = UIFont(name: "Kanit-Regular", size: Dimensions.subHeadingFont)
        label.textColor = UIColor(named: "Gray")
        return label
    }()
    
    let signInLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "sign in"
        label.font = UIFont(name: "Kanit-Regular", size: Dimensions.subHeadingFont)
        label.textColor = UIColor(named: "Red")
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let usernameTextFieldView: TextFieldView = TextFieldView()
    let emailTextFieldView: TextFieldView = TextFieldView()
    let passwordTextFieldView: TextFieldView = TextFieldView()
    
    let signUpButton: PrimaryButton = PrimaryButton()
    
    var signUpButtonBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: "Background")

        self.cancelView.setup(in: self.view)
        self.setupViewLabels()
        self.setupSignInLabels()
        self.setupSignUpButton()
        self.setupScrollView()
        self.setupTextFieldViews()

        let cancelViewTap = UITapGestureRecognizer(target: self, action: #selector(closeView))
        self.cancelView.addGestureRecognizer(cancelViewTap)
        
        // Close keyboard on external tap.
        let externalKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(externalKeyboardTap)
        
        let signInTap = UITapGestureRecognizer(target: self, action: #selector(onSignIn))
        self.signInLabel.addGestureRecognizer(signInTap)
        
        // On keyboard show and hide notification move UI elements.
        self.configureKeyboardNotifications()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTextFieldView.textField:
            usernameTextFieldView.textField.resignFirstResponder()
            emailTextFieldView.textField.becomeFirstResponder()
        case emailTextFieldView.textField:
            emailTextFieldView.textField.resignFirstResponder()
            passwordTextFieldView.textField.becomeFirstResponder()
        case passwordTextFieldView.textField:
            passwordTextFieldView.textField.resignFirstResponder()
            self.sendRegisterRequest()
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
        if usernameTextFieldView.textField.isEditing || emailTextFieldView.textField.isEditing || passwordTextFieldView.textField.isEditing {
            moveWithKeyboard(on: notification, by: -10, this: signUpButtonBottomConstraint, up: true)
        }
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        moveWithKeyboard(on: notification, by: -Dimensions.verticalSpacing20 - self.signInStackView.frame.height - 10, this: signUpButtonBottomConstraint, up: false)
    }
    
    @objc func onSignUpTouchDown() {
        self.signUpButton.onTouchDown()
    }

    @objc func onSignUpTouchUpOutside() {
        self.signUpButton.onTouchUpOutside()
    }

    @objc func onSignUp() {
        self.sendRegisterRequest()
    }
    
    @objc func onSignIn() {
        let loginStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: .main)
        let loginViewController: LoginViewController = loginStoryboard.instantiateViewController(identifier: "LoginScreen")

        loginViewController.mainViewController = self.mainViewController

        self.present(loginViewController, animated: true)
    }
    
    private func sendRegisterRequest() {
        // Hide keyboard if open.
        self.view.endEditing(true)
        
        self.signUpButton.disable()
        
        guard let username = usernameTextFieldView.textField.text, let password = passwordTextFieldView.textField.text, let email = emailTextFieldView.textField.text else {
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
    
    private func setupViewLabels() {
        self.viewTitle.setup(in: self.view, as: "Sign up 🫵")
        self.viewSubtitle.setup(in: self.view, as: "create account and play competitive games, save game histories, and 🔜  send friend requests and much more")
        
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
            self.scrollView.bottomAnchor.constraint(equalTo: self.signUpButton.topAnchor, constant: -Dimensions.verticalSpacing20)
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
        self.stackView.addArrangedSubview(self.emailTextFieldView)
        self.stackView.addArrangedSubview(self.passwordTextFieldView)
    }
    
    private func setupTextFieldViews() {
        self.usernameTextFieldView.text = "Username"
        self.usernameTextFieldView.textField.delegate = self
        self.usernameTextFieldView.textField.keyboardType = .namePhonePad
        self.usernameTextFieldView.textField.textContentType = .username
        self.usernameTextFieldView.textField.returnKeyType = .continue
        self.usernameTextFieldView.textField.setup(with: "Create your username")
        
        self.emailTextFieldView.text = "Email"
        self.emailTextFieldView.textField.delegate = self
        self.emailTextFieldView.textField.keyboardType = .emailAddress
        self.emailTextFieldView.textField.textContentType = .emailAddress
        self.emailTextFieldView.textField.returnKeyType = .continue
        self.emailTextFieldView.textField.setup(with: "Enter your email")
        
        self.passwordTextFieldView.text = "Password"
        self.passwordTextFieldView.textField.delegate = self
        self.passwordTextFieldView.textField.keyboardType = .default
        self.passwordTextFieldView.textField.textContentType = .newPassword
        self.passwordTextFieldView.textField.returnKeyType = .done
        self.passwordTextFieldView.textField.isSecureTextEntry = true
        self.passwordTextFieldView.textField.setup(with: "Create new password")
    }
    
    private func setupSignUpButton() {
        self.signUpButton.addTarget(self, action: #selector(onSignUp), for: .touchUpInside)
        self.signUpButton.addTarget(self, action: #selector(onSignUpTouchUpOutside), for: .touchUpOutside)
        self.signUpButton.addTarget(self, action: #selector(onSignUpTouchDown), for: .touchDown)
        
        self.signUpButton.width = UIScreen.main.bounds.width - 40
        self.signUpButton.height = self.signUpButton.width / 8
        self.signUpButton.setup(in: self.view, withTitle: "Sign up")
        
        self.view.layoutIfNeeded()
        
        self.signUpButtonBottomConstraint = self.signUpButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -Dimensions.verticalSpacing20 - self.signInStackView.frame.height - 10)
        
        NSLayoutConstraint.activate([
            self.signUpButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.signUpButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.signUpButtonBottomConstraint
        ])
    }
    
    private func setupSignInLabels() {
        self.view.addSubview(signInStackView)

        self.signInStackView.addArrangedSubview(signInPromptLabel)
        self.signInStackView.addArrangedSubview(signInLabel)
        
        NSLayoutConstraint.activate([
            self.signInStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.signInStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
}
