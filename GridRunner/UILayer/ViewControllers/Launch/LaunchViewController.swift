//
//  LaunchViewController.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 12.06.23.
//

import UIKit

class LaunchViewController: UIViewController {

    // When coming from universal link this value will be set to the parameter value from universal link.
    var roomCode: String?
    var forceUpgrade: Bool = false
    let alertAdapter: AlertAdapter = AlertAdapter()
    
    @IBOutlet weak var loadingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadingLabel.text = "Fetching user preferences..."
        
        // Check API version. If API version needs force upgrade show pop up.
        // Make API call to check for API availability
        if isAPIAvailable() {
            DispatchQueue.main.async {
                let alert = self.alertAdapter.createForceUpgradeAlert(completion: self.transitionToMainScreen)
                self.present(alert, animated: true)
            }
        } else {
            self.transitionToMainScreen()
        }
    }

    private func transitionToMainScreen() {
        self.retrieveUserSession { _ in
            let mainViewController: MainViewController = MainViewController()
            mainViewController.roomCode = self.roomCode
            
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            sceneDelegate?.transitionViewController.transition(to: mainViewController, with: [.transitionCurlUp]) {
                guard self.roomCode != nil else  { return }
                
                mainViewController.openJoinRoomAlert()
            }
        }
    }
    
    private func isAPIAvailable() -> Bool {
        self.forceUpgrade
    }
    
    private func retrieveUserSession(completion: @escaping (Response) -> Void) {
        let session = UserDefaults.standard.value(forKey: "session")
        if let session = session {
            UserService().getUser() { response in
                DispatchQueue.main.async {
                    if response == .success {
                        NSLog("User retrieval completed successfully. Session: \(session)")
                        completion(.success)
                    } else {
                        NSLog("Cannot get User.")
                        completion(.requestError)
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                NSLog("No session found.")
                completion(.requestError)
            }
        }
    }
}
