//
//  ViewController.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 03.05.23.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {

    // Override device orienation settings.
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    // Storyboard properties.
    @IBOutlet weak var codeRoomTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Manage delegate to override UITextField methods.
        codeRoomTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    @IBAction func onLogin(_ sender: Any) {
        let registerStoryboard: UIStoryboard = UIStoryboard(name: "Register", bundle: .main)
        let registerViewController = registerStoryboard.instantiateViewController(withIdentifier: "RegisterScreen")
        
        if let registerPresentationController = registerViewController.presentationController as? UISheetPresentationController {
            registerPresentationController.detents = [.medium(), .large()]
        }
        
        self.present(registerViewController, animated: true)
    }
    
    @IBAction func onCopyRoomCode(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = codeRoomTextField.text
    }
    
    @IBAction func onPlayWithFriend(_ sender: Any) {
        let gameStoryboard: UIStoryboard = UIStoryboard(name: "Game", bundle: .main)
        let gameViewController: UIViewController = gameStoryboard.instantiateViewController(identifier: "GameScreen") as GameViewController
        
        self.view.window?.rootViewController = gameViewController
    }
    
    
    @IBAction func onPlayWithRandoms(_ sender: Any) {
        let gameStoryboard: UIStoryboard = UIStoryboard(name: "Game", bundle: .main)
        let gameViewController: UIViewController = gameStoryboard.instantiateViewController(identifier: "GameScreen") as GameViewController
        
        self.view.window?.rootViewController = gameViewController
    }
}

