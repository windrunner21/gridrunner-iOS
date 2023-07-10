//
//  LaunchViewController.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 12.06.23.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBOutlet weak var loadingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadingLabel.text = "Fetching user preferences..."
        
        AppDelegate.shared.performNetworkRequest { _ in
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
            let mainViewController: UIViewController = mainStoryboard.instantiateViewController(identifier: "MainScreen") as MainViewController
            
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            sceneDelegate?.transitionViewController.transition(to: mainViewController, with: [.transitionCurlUp])
        }
    }

}
