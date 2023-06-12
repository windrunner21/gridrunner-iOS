//
//  ViewController.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 03.05.23.
//

import UIKit

class MainViewController: UIViewController {
    
    let alertAdapter = AlertAdapter()
    
    // Storyboard properties.
    @IBOutlet weak var rankView: UIView!
    @IBOutlet weak var trophyIconView: UIView!
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var emojiIconView: UIView!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var quickPlayView: MenuItemView!
    @IBOutlet weak var rankedPlayView: MenuItemView!
    @IBOutlet weak var roomPlayView: MenuItemView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if the user is authenticated.
        self.checkUserAuthentication()
        
        self.rankView.transformToCircle()
        self.trophyIconView.transformToCircle()
        self.profileView.transformToCircle()
        self.emojiIconView.transformToCircle()
        
        // Adding elevation/shadow to cancel view
        self.profileView.addButtonElevation()
        
        // Set random emoji from profile icon to emoji label.
        self.emojiLabel.text = ProfileIcon().getEmoji()
        
        // Open user profile menu on profile view tap.
        let openProfileMenuTap = UITapGestureRecognizer(target: self, action: #selector(openProfileMenu))
        self.profileView.addGestureRecognizer(openProfileMenuTap)
        
        let interaction = UIContextMenuInteraction(delegate: self)
        self.profileView.addInteraction(interaction)
    
        // Decorate and set up visually menu items.
        self.setUpMenuItems()
    }
    
    @objc func openProfileMenu(_ gesture: UITapGestureRecognizer) {
        User.shared.isLoggedIn ? self.openAccountModal() : self.openRegisterModal()
    }
    
    private func startGame() {
        let gameStoryboard: UIStoryboard = UIStoryboard(name: "Game", bundle: .main)
        let gameViewController: UIViewController = gameStoryboard.instantiateViewController(identifier: "GameScreen") as GameViewController
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.transitionViewController.transition(to: gameViewController, with: [.transitionCurlUp])
    }
    
    private func openRegisterModal() {
        let registerStoryboard: UIStoryboard = UIStoryboard(name: "Register", bundle: .main)
        let registerViewController: RegisterViewController = registerStoryboard.instantiateViewController(identifier: "RegisterScreen")
        
        registerViewController.mainViewController = self
        
        self.present(registerViewController, animated: true)
    }
    
    private func openLoginModal() {
        let loginStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: .main)
        let loginViewController: LoginViewController = loginStoryboard.instantiateViewController(identifier: "LoginScreen")
        
        loginViewController.mainViewController = self
        
        self.present(loginViewController, animated: true)
    }
    
    private func openAccountModal() {
        let profileStoryboard: UIStoryboard = UIStoryboard(name: "Profile", bundle: .main)
        let profileViewController: ProfileViewController = profileStoryboard.instantiateViewController(identifier: "ProfileScreen")
        
        profileViewController.mainViewController = self
        
        self.present(profileViewController, animated: true)
    }
    
    func checkUserAuthentication() {
        // Check if the user is authenticated.
        self.rankView.isHidden = !User.shared.isLoggedIn
        self.rankLabel.text = "\(User.shared.runnerElo) GRank"
        self.usernameLabel.text = "@\(User.shared.username)"
        
        self.rankedPlayView.shouldBeEnabled(
            if: User.shared.isLoggedIn,
            iconAndDescription: (icon: "🥇", description: "play for rank and move up the \"best\" ladder"),
            else: (icon: "🔒", description: "create or login into account to start playing ranked")
        )
    }
    
    private func setUpMenuItems() {
        self.quickPlayView.decorateMenuItem(
            icon: "🎲",
            title: "Quick Play with Randoms",
            description: "find your opponent around the world",
            image: "MapIcon"
        )
        
        self.transformWhite(view: self.quickPlayView, angle: 1.5)
        
        self.quickPlayView.playNowButtonAction = { [weak self] in
            self?.startGame()
        }
        
        self.rankedPlayView.decorateMenuItem(
            icon: "🥇",
            title: "Competitive Play",
            description: "play for rank and move up the \"best\" ladder",
            image: "WorldIcon"
        )
        
        self.rankedPlayView.playNowButtonAction = { [weak self] in
            self?.startGame()
        }
        
        self.rankedPlayView.shouldBeEnabled(
            if: User.shared.isLoggedIn,
            iconAndDescription: (icon: "🥇", description: "play for rank and move up the \"best\" ladder"),
            else: (icon: "🔒", description: "create or login into account to start playing ranked")
        )
        
        self.roomPlayView.decorateMenuItem(
            icon: "🤝",
            title: "Play with a Friend",
            description: "enter room code and jump into the game",
            image: "FriendsIcon"
        )
        
        self.roomPlayView.playNowButtonAction = { [weak self] in
            self?.startGame()
        }
        
        self.transformWhite(view: self.roomPlayView, angle: -1.5)
    }
    
    // Decorate menu item view with specified color and angle.
    private func transformWhite(view: MenuItemView, angle: CGFloat?) {
        let radians = (angle ?? 0) * Double.pi / 180
        view.contentView.backgroundColor = .white
        view.playModeLabel.textColor = UIColor(named: "FrostBlackColor")
        view.transform = CGAffineTransform(rotationAngle: radians)
    }
}

extension MainViewController: UIContextMenuInteractionDelegate {
      func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            
            // Create an action for signing in.
            let login = UIAction(title: "Login", image: UIImage(systemName: "door.right.hand.open")) { action in
                self.openLoginModal()
            }
            
            // Create an action for signing in.
            let register = UIAction(title: "Register", image: UIImage(systemName: "door.right.hand.open")) { action in
                self.openRegisterModal()
            }
            
            let account = UIAction(title: "Account", image: UIImage(systemName: "person.circle.fill")) { action in
                self.openLoginModal()
            }
    
            // Here we specify the "destructive" attribute to show that it’s destructive in nature.
            let logout = UIAction(title: "Log out", image: UIImage(systemName: "door.right.hand.closed"), attributes: .destructive) { _ in
                AuthService().logout { response in
                    DispatchQueue.main.async {
                        switch response {
                        case .success:
                            self.checkUserAuthentication()
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
    
            // Create and return a UIMenu with all of the actions as children
            
            var children: [UIMenuElement] {
                if User.shared.isLoggedIn {
                    return [account, logout]
                } else {
                    return [login, register]
                }
            }
            return UIMenu(title: "", children: children)
        }
    }
}

