//
//  ProfileViewController.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 12.06.23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var mainViewController: MainViewController!
    var alertAdapter: AlertAdapter = AlertAdapter()
    var profileIcon: ProfileIcon!
    
    // Storyboard related properties.
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var emojiIconView: UIView!
    
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var runnerRankView: UIView!
    @IBOutlet weak var seekerRankView: UIView!
    
    @IBOutlet weak var runnerGR: UILabel!
    @IBOutlet weak var seekerGR: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.logoutButton.setup()
        
        self.cancelView.transformToCircle()
        self.emojiIconView.transformToCircle()
        self.profileView.transformToCircle()
        
        // Adding elevation/shadow to cancel view
        self.cancelView.addButtonElevation()

        self.profileView.addLightBorder()
        
        self.runnerRankView.layer.cornerRadius = 10
        self.runnerRankView.backgroundColor = UIColor(named: "SecondaryColor")?.withAlphaComponent(0.25)
        self.seekerRankView.layer.cornerRadius = 10
        self.seekerRankView.backgroundColor = UIColor(named: "SecondaryColor")?.withAlphaComponent(0.25)
        
        // Set random emoji from profile icon to emoji label.
        self.emojiLabel.text = profileIcon.getIcon()
        
        self.usernameLabel.text = User.shared.username
        self.emailLabel.text = User.shared.email
        self.runnerGR.text = String(User.shared.runnerElo)
        self.seekerGR.text = String(User.shared.seekerElo)
        
        // Close current view, dismiss with animation, on cancel view tap.
        let cancelViewTap = UITapGestureRecognizer(target: self, action: #selector(closeView))
        self.cancelView.addGestureRecognizer(cancelViewTap)
    }
    
    @objc func closeView() {
        self.mainViewController.dismiss(animated: true)
    }
    
    @IBAction func onLogoutTouchDown(_ sender: Any) {
        self.logoutButton.onTouchDown()
    }
    
    
    @IBAction func onLogoutTouchUpOutside(_ sender: Any) {
        self.logoutButton.onTouchUpOutside()
    }
    
    @IBAction func onLogout(_ sender: Any) {
        self.logoutButton.disable()
        AuthService().logout { response in
            DispatchQueue.main.async {
                self.logoutButton.enable()
                
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
