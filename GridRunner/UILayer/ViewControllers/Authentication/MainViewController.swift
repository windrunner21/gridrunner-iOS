//
//  ViewController.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 03.05.23.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {
    
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

        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.transitionViewController.transition(to: gameViewController, with: [.transitionCurlUp])
    }
    
    @IBAction func onPlayWithRandoms(_ sender: Any) {
        let gameStoryboard: UIStoryboard = UIStoryboard(name: "Game", bundle: .main)
        let gameViewController: UIViewController = gameStoryboard.instantiateViewController(identifier: "GameScreen") as GameViewController
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.transitionViewController.transition(to: gameViewController, with: [.transitionCurlUp])
    }
}

