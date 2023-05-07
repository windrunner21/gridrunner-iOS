//
//  ViewController.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 03.05.23.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {

    
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

