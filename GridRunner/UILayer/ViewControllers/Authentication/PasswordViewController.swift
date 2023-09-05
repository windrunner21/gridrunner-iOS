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
        label.text = "remembered your password?"
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
    
    let emailTextFieldView: TextFieldView = TextFieldView()
  
    let resetPasswordButton: PrimaryButton = PrimaryButton()
    
    @IBOutlet weak var resetPasswordButtonBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(named: "Background")

        self.cancelView.setup(in: self.view)
        self.setupViewLabels()
        self.setupSignInLabels()
        self.setupResetPasswordButton()
        self.setupScrollView()
        self.setupTextFieldViews()
        
        // Close current view, dismiss with animation, on cancel view tap.
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
        case emailTextFieldView.textField:
            emailTextFieldView.textField.resignFirstResponder()
            self.sendResetPasswordRequest()
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
        if emailTextFieldView.textField.isEditing {
            moveWithKeyboard(on: notification, by: -10, this: resetPasswordButtonBottomConstraint, up: true)
        }
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        moveWithKeyboard(on: notification, by: -Dimensions.verticalSpacing20 - self.signInStackView.frame.height - 10, this: resetPasswordButtonBottomConstraint, up: false)
    }
    
    
    @objc func onResetPasswordTouchDown() {
        self.resetPasswordButton.onTouchDown()
    }
    
    @objc func onResetPasswordTouchUpOutside() {
        self.resetPasswordButton.onTouchUpOutside()
    }
    
    @objc func onResetPassword() {
        self.sendResetPasswordRequest()
    }
    
    @objc func onSignIn() {
        self.dismiss(animated: true)
    }
    
    private func sendResetPasswordRequest() {
        // Hide keyboard if open.
        self.view.endEditing(true)
        
        self.resetPasswordButton.disable()
        
        guard let email = emailTextFieldView.textField.text else {
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
    
    private func setupViewLabels() {
        self.viewTitle.setup(in: self.view, as: "Reset password 🆕")
        self.viewSubtitle.setup(in: self.view, as: "don't worry, you can easily reset password by entering your email address")
        
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
            self.scrollView.bottomAnchor.constraint(equalTo: self.resetPasswordButton.topAnchor, constant: -Dimensions.verticalSpacing20)
        ])
        
        self.scrollView.addSubview(self.stackView)
        
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: Dimensions.verticalSpacing20),
            self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20),
            self.stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -20),
            self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -Dimensions.verticalSpacing20),
            self.stackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40)
        ])
        
        self.stackView.addArrangedSubview(self.emailTextFieldView)
    }
    
    private func setupTextFieldViews() {
        self.emailTextFieldView.text = "Email"
        self.emailTextFieldView.textField.delegate = self
        self.emailTextFieldView.textField.keyboardType = .emailAddress
        self.emailTextFieldView.textField.textContentType = .emailAddress
        self.emailTextFieldView.textField.returnKeyType = .continue
        self.emailTextFieldView.textField.setup(with: "Enter your email")
    }
    
    private func setupResetPasswordButton() {
        self.resetPasswordButton.addTarget(self, action: #selector(onResetPassword), for: .touchUpInside)
        self.resetPasswordButton.addTarget(self, action: #selector(onResetPasswordTouchUpOutside), for: .touchUpOutside)
        self.resetPasswordButton.addTarget(self, action: #selector(onResetPasswordTouchDown), for: .touchDown)
        
        self.resetPasswordButton.width = UIScreen.main.bounds.width - 40
        self.resetPasswordButton.height = self.resetPasswordButton.width / 8
        self.resetPasswordButton.setup(in: self.view, withTitle: "Reset password")
        
        // Update frame to set correct sign up button bottom constraint.
        self.view.layoutIfNeeded()
        
        self.resetPasswordButtonBottomConstraint = self.resetPasswordButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -Dimensions.verticalSpacing20 - self.signInStackView.frame.height - 10)
        
        NSLayoutConstraint.activate([
            self.resetPasswordButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.resetPasswordButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.resetPasswordButtonBottomConstraint
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
