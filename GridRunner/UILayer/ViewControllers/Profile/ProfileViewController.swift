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
        
        self.setupCancelView()
        self.setupProfileView()
        self.setupProfileLabels()
        self.setupRankViews()
        self.setupProfileItemViews()
        
        // MARK: to do later
        // self.setupGrayBackgroundColor()
        
        // Close current view, dismiss with animation, on cancel view tap.
        let cancelViewTap = UITapGestureRecognizer(target: self, action: #selector(closeView))
        self.cancelView.addGestureRecognizer(cancelViewTap)
    }
    
    @objc func closeView() {
        self.mainViewController.dismiss(animated: true)
    }
    
//    @IBAction func onLogoutTouchDown(_ sender: Any) {
//        self.logoutButton.onTouchDown()
//    }
//    
//    @IBAction func onDeleteAccountTouchDown(_ sender: Any) {
//        self.deleteAccountButton.onTouchDown()
//    }
//    
//    @IBAction func onLogoutTouchUpOutside(_ sender: Any) {
//        self.logoutButton.onTouchUpOutside()
//    }
//    
//    @IBAction func onDeleteAccountTouchUpOutside(_ sender: Any) {
//        self.deleteAccountButton.onTouchUpOutside()
//    }
//    
//    @IBAction func onLogout(_ sender: Any) {
//        self.logoutButton.disable()
//        AuthService().logout { response in
//            DispatchQueue.main.async {
//                self.logoutButton.enable()
//                
//                switch response {
//                case .success:
//                    self.mainViewController.checkUserAuthentication()
//                    self.mainViewController.dismiss(animated: true)
//                case .networkError:
//                    let alert = self.alertAdapter.createNetworkErrorAlert()
//                    self.present(alert, animated: true)
//                case .requestError:
//                    let alert = self.alertAdapter.createServiceRequestErrorAlert()
//                    self.present(alert, animated: true)
//                case .decoderError:
//                    let alert = self.alertAdapter.createDecoderErrorAlert()
//                    self.present(alert, animated: true)
//                }
//            }
//        }
//    }
//    
//    @IBAction func onDeleteAccount(_ sender: Any) {
//        self.deleteAccountButton.disable()
//        
//        AuthService().deleteAccount { response in
//            DispatchQueue.main.async {
//                self.deleteAccountButton.enable()
//                
//                switch response {
//                case .success:
//                    self.mainViewController.checkUserAuthentication()
//                    self.mainViewController.dismiss(animated: true)
//                case .networkError:
//                    let alert = self.alertAdapter.createNetworkErrorAlert()
//                    self.present(alert, animated: true)
//                case .requestError:
//                    let alert = self.alertAdapter.createServiceRequestErrorAlert()
//                    self.present(alert, animated: true)
//                case .decoderError:
//                    let alert = self.alertAdapter.createDecoderErrorAlert()
//                    self.present(alert, animated: true)
//                }
//            }
//        }
//    }
    
    private func setupCancelView() {
        self.cancelView.setup(in: self.view)
        
        NSLayoutConstraint.activate([
            self.cancelView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            self.cancelView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
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
        
        self.runnerRank.rankType = .runner
        self.seekerRank.rankType = .seeker
        
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
        
        self.view.addSubview(self.logoutView)
        
        NSLayoutConstraint.activate([
            self.logoutView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            self.logoutView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.logoutView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupGrayBackgroundColor() {
        let grayLayer = CALayer()
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        grayLayer.backgroundColor = UIColor.systemGray6.cgColor
        print(self.emailLabel.frame)
        let yPosition = self.emailLabel.frame.maxY + 20
 
        grayLayer.frame = CGRect(x: 0, y: yPosition, width: screenWidth, height: screenHeight - yPosition)
        
        self.view.layer.insertSublayer(grayLayer, at: 0)
    }
}
