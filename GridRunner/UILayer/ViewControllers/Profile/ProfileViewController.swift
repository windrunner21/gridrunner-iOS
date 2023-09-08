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
    
    // Programmable UI properties.
    let grayLayer = CALayer()
    let cancelView: CancelView = CancelView()
    let profileView: ProfileView = ProfileView()
    
    let usernameLabel: UILabel = UILabel()
    let emailLabel: UILabel = UILabel()
    
    let runnerRank: RankView = RankView()
    let seekerRank: RankView = RankView()
    
    let logoutView: ProfileItemView = ProfileItemView()
    let deleteAccountView: ProfileItemView = ProfileItemView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: "Background")
        
        self.cancelView.setup(in: self.view)
        self.setupProfileView()
        self.setupProfileLabels()
        self.setupRankViews()
        self.setupProfileItemViews()
        self.setupGrayBackgroundColor()
    
        // Close current view, dismiss with animation, on cancel view tap.
        let cancelViewTap = UITapGestureRecognizer(target: self, action: #selector(closeView))
        self.cancelView.addGestureRecognizer(cancelViewTap)
        
        let logoutLongPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        logoutLongPress.minimumPressDuration = 0
        let deleteAccountLongPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        deleteAccountLongPress.minimumPressDuration = 0
        
        self.logoutView.addGestureRecognizer(logoutLongPress)
        self.deleteAccountView.addGestureRecognizer(deleteAccountLongPress)
    }
    
    @objc func closeView() {
        self.mainViewController.dismiss(animated: true)
    }

    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        switch gestureRecognizer.view {
        case self.logoutView:
            self.handleViewChanges(
                in: self.logoutView,
                for: gestureRecognizer,
                completion: self.onLogout(caller: self.logoutView)
            )
        case self.deleteAccountView:
            self.handleViewChanges(
                in: self.deleteAccountView,
                for: gestureRecognizer,
                completion: self.onDeleteAccount(caller: self.deleteAccountView)
            )
        default:
            break
        }
    }
    
    private func handleViewChanges(in view: UIView, for gestureRecognizer: UILongPressGestureRecognizer, completion: ()) {
        switch gestureRecognizer.state {
        case .began, .changed:
            view.alpha = 0.3
        case .ended:
            completion
        default:
            break
        }
    }
    
    private func onLogout(caller view: UIView) {
        AuthService().logout { response in
            DispatchQueue.main.async {
                view.alpha = 1

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
    
    private func onDeleteAccount(caller view: UIView) {
        AuthService().deleteAccount { response in
            DispatchQueue.main.async {
                view.alpha = 1

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
    
    private func setupProfileView() {
        self.profileView.textSize = Dimensions.largeFont
        self.profileView.setSize(to: Dimensions.roundViewHeight * 2)
        self.profileView.setup(in: self.view)
        
        NSLayoutConstraint.activate([
            self.profileView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.profileView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: Dimensions.verticalSpacing20 * 4)
        ])
    }
    
    private func setupProfileLabels() {
        self.usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.emailLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.usernameLabel.font = UIFont(name: "Kanit-Semibold", size: Dimensions.headingFont)
        self.emailLabel.font = UIFont(name: "Kanit-Regular", size: Dimensions.subHeadingFont)
        
        self.emailLabel.textColor = UIColor(named: "Black")
        self.emailLabel.textColor = UIColor(named: "Gray")
        
        self.usernameLabel.text = User.shared.username
        self.emailLabel.text = User.shared.email
        
        self.usernameLabel.textAlignment = .center
        self.emailLabel.textAlignment = .center
        
        self.view.addSubview(usernameLabel)
        self.view.addSubview(emailLabel)
        
        NSLayoutConstraint.activate([
            self.usernameLabel.topAnchor.constraint(equalTo: self.profileView.bottomAnchor, constant: 10),
            self.usernameLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: Dimensions.verticalSpacing20),
            self.usernameLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -Dimensions.verticalSpacing20),
            
            self.emailLabel.topAnchor.constraint(equalTo: self.usernameLabel.bottomAnchor, constant: 0),
            self.emailLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: Dimensions.verticalSpacing20),
            self.emailLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -Dimensions.verticalSpacing20)
        ])
    }
    
    private func setupRankViews() {
        self.runnerRank.rank = User.shared.runnerElo
        self.seekerRank.rank = User.shared.seekerElo
        
        self.runnerRank.playerType = .runner
        self.seekerRank.playerType = .seeker
        
        self.runnerRank.backgroundColor = UIColor(named: "Background")
        self.seekerRank.backgroundColor = UIColor(named: "Background")
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        
        self.view.addSubview(stackView)
        
        stackView.addArrangedSubview(runnerRank)
        stackView.addArrangedSubview(seekerRank)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.emailLabel.bottomAnchor, constant: Dimensions.verticalSpacing20 * 2),
            stackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupProfileItemViews() {
        self.logoutView.title = "Logout"
        self.logoutView.image = "arrow.left.circle.fill"
        self.logoutView.imageColor = UIColor(named: "Red")
        self.logoutView.textColor = UIColor(named: "Black")
        self.logoutView.backgroundColor = UIColor(named: "Background")
        
        self.deleteAccountView.title = "Delete Account"
        self.deleteAccountView.image = "trash.circle.fill"
        self.deleteAccountView.imageColor = UIColor(named: "Background")
        self.deleteAccountView.textColor = UIColor(named: "Background")
        self.deleteAccountView.backgroundColor = UIColor(named: "Red")
        
        self.view.addSubview(self.logoutView)
        self.view.addSubview(self.deleteAccountView)
        
        NSLayoutConstraint.activate([
            self.deleteAccountView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            self.deleteAccountView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.deleteAccountView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.logoutView.bottomAnchor.constraint(equalTo: self.deleteAccountView.topAnchor, constant: -20),
            self.logoutView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.logoutView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
        ])
    }
    
    private func setupGrayBackgroundColor() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        self.grayLayer.backgroundColor = UIColor.systemGray6.cgColor
        self.view.layoutIfNeeded()
        let yPosition = self.emailLabel.frame.maxY + Dimensions.verticalSpacing20
        
        grayLayer.frame = CGRect(x: 0, y: yPosition, width: screenWidth, height: screenHeight - yPosition)
        
        self.view.layer.insertSublayer(grayLayer, at: 0)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
       super.traitCollectionDidChange(previousTraitCollection)
       self.grayLayer.backgroundColor = UIColor.systemGray6.cgColor
     }
}
