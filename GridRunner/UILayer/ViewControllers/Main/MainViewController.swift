//
//  ViewController.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 03.05.23.
//

import UIKit

class MainViewController: UIViewController {
    
    // When coming from universal link this value will be set to the parameter value from universal link.
    var roomCode: String?
    
    private let alertAdapter = AlertAdapter()
    private let gameSearchView = GameSearchView(
        frame: CGRect(
            x: UIScreen.main.bounds.width / 2 - UIScreen.main.bounds.width / 3,
            y: 0,
            width: UIScreen.main.bounds.width / 1.5,
            height: 150
        )
    )
    
    // Programmable UI properties.
    private let gridRunLabel: GridRunLabel = GridRunLabel()
    private let versionLabel: VersionLabel = VersionLabel()
    private let profileView: ProfileView = ProfileView()
    
    private let joinRoomButton: MenuButton = MenuButton()
    private let createRoomButton: MenuButton = MenuButton()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = Dimensions.verticalSpacing20
        return stackView
    }()
    
    private let quickPlayView: MenuItemView = MenuItemView()
    private let rankedPlayView: MenuItemView = MenuItemView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "Background")

        // Setup programmable UIs.
        self.setupGridRunLabel()
        self.setupVersionLabel()
        
        self.setupProfileView()
        self.setupMenuButtons()
        
        self.setupScrollView()
        
        // Open user profile menu on profile view tap.
        let openProfileMenuTap = UITapGestureRecognizer(target: self, action: #selector(openProfileMenu))
        self.profileView.addGestureRecognizer(openProfileMenuTap)
        
        // Decorate and set up visually menu items.
       self.setUpMenuItems()
        
        // Check if the user is authenticated.
        self.checkUserAuthentication()
        
        NotificationCenter.default.addObserver(self, selector: #selector(openGameScreen), name: NSNotification.Name("Success::Matchmaking"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(openCustomGameScreen), name: NSNotification.Name("Success::Matchmaking::Custom"), object: nil)
    }
    
    @objc func openGameScreen(_ notification: Notification) {
        self.startGame(custom: false, isJoining: false)
    }
    
    @objc func openCustomGameScreen(_ notification: Notification) {
        self.startGame(custom: true, isJoining: false)
    }
    
    @objc func openProfileMenu(_ gesture: UITapGestureRecognizer) {
        User.shared.isLoggedIn ? self.openAccountScreen() : self.openRegisterScreen()
    }
    
    private func searchGame(by gameType: GameType) {
        self.gameSearchView.setup(with: gameType, and: "Searching for opponents...")
        self.view.addSubview(gameSearchView)
        self.gameSearchView.slideIn()
        
        AblyJWTService().getJWT() { response, token in
            
            switch response {
            case .success:
                guard let token = token else {
                    DispatchQueue.main.async {
                        let alert = self.alertAdapter.createNetworkErrorAlert()
                        self.present(alert, animated: true)
                    }
                    return
                }
                
                let channelName: String = {
                    switch gameType {
                    case .quickplay:
                        return "quick-play-queue"
                    case .rankedplay:
                        return "ranked-play-queue"
                    case .roomplay:
                        return "quick-play-queue"
                    }
                }()
                
                AblyService.shared.update(with: token, and: channelName)
                AblyService.shared.enterQueue()
            case .requestError:
                DispatchQueue.main.async {
                    self.gameSearchView.slideOut()
                    let alert = self.alertAdapter.createServiceRequestErrorAlert()
                    self.present(alert, animated: true)
                }
            default:
                DispatchQueue.main.async {
                    self.gameSearchView.slideOut()
                    let alert = self.alertAdapter.createNetworkErrorAlert()
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    private func startGame(custom: Bool, isJoining: Bool) {
        // Set notification for successful matchmaking.
        Notifications.scheduleMatchmakingNotification()
        
        let gameViewController: GameViewController = GameViewController()
        gameViewController.ordinaryLoading = !custom
        gameViewController.fromJoiningRoom = isJoining
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.transitionViewController.transition(to: gameViewController, with: [.transitionCurlUp])
    }
    
    private func openRegisterScreen() {
        let registerViewController: RegisterViewController = RegisterViewController()
        registerViewController.mainViewController = self
        self.present(registerViewController, animated: true)
    }
        
    private func openAccountScreen() {
        let profileViewController: ProfileViewController = ProfileViewController()
        profileViewController.mainViewController = self
        self.present(profileViewController, animated: true)
    }
    
    private func openCreateRoomScreen() {
        let createRoomViewController: CreateRoomViewController = CreateRoomViewController()
        createRoomViewController.mainViewController = self
        self.present(createRoomViewController, animated: true)
    }
    
    // Function is public to be called when needed by universal link.
    func openJoinRoomAlert() {
        let loadingOverlayView = LoadingOverlayView()
        self.view.addSubview(loadingOverlayView)
        
        let alert = self.alertAdapter.createJoinRoomAlert(withCode: roomCode, loadingOverlayView: loadingOverlayView) { errorAlert, response in
            UIView.animate(withDuration: 0.3, animations: {
                loadingOverlayView.removeFromSuperview()
                
                if let errorAlert = errorAlert {
                    self.present(errorAlert, animated: true)
                    return
                }
                
                if response == .success {
                    self.startGame(custom: false, isJoining: true)
                }
            })
        }
        
        // Remove room code from universal link after one use.
        self.roomCode = nil
        self.present(alert, animated: true)
    }
    
    func checkUserAuthentication() {
        self.rankedPlayView.shouldBeEnabled(
            if: User.shared.isLoggedIn,
            iconAndDescription: (icon: "🏆", description: "play for rank and become the best"),
            else: (icon: "🔒", description: "login into account to play ranked")
        )
    }
    
    private func setUpMenuItems() {
        self.quickPlayView.color = .systemGray6
        self.quickPlayView.decorateMenuItem(
            icon: "🎲",
            title: "Unranked",
            description: "find your opponent around the world",
            image: "MapIcon"
        )
        
        self.quickPlayView.playNowButtonAction = { [weak self] in
            self?.searchGame(by: .quickplay)
        }
        
        self.rankedPlayView.color = .systemGray6
        self.rankedPlayView.decorateMenuItem(
            icon: "🏆",
            title: "Competitive",
            description: "play for rank and become the best",
            image: "WorldIcon"
        )
        
        self.rankedPlayView.playNowButtonAction = { [weak self] in
            self?.searchGame(by: .rankedplay)
        }
    }
    
    private func setupGridRunLabel() {
        self.gridRunLabel.setup(in: self.view)
        
        NSLayoutConstraint.activate([
            self.gridRunLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.gridRunLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
    }
    
    private func setupProfileView() {
        self.profileView.textSize = Dimensions.buttonFont
        self.profileView.isButton = true
        self.profileView.setup(in: self.view)
        
        NSLayoutConstraint.activate([
            self.profileView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.profileView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupMenuButtons() {
        joinRoomButton.icon = "➡️"
        joinRoomButton.text = "Join Room"
        joinRoomButton.menuAction = { [weak self] in
            self?.openJoinRoomAlert()
        }
        
        createRoomButton.icon = "🆕"
        createRoomButton.text = "Create Room"
        createRoomButton.menuAction = { [weak self] in
            self?.openCreateRoomScreen()
        }
        
        self.view.addSubview(joinRoomButton)
        self.view.addSubview(createRoomButton)
        
        NSLayoutConstraint.activate([
            self.joinRoomButton.topAnchor.constraint(equalTo: self.gridRunLabel.bottomAnchor, constant: Dimensions.verticalSpacing20 * 1.5),
            self.joinRoomButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            self.createRoomButton.topAnchor.constraint(equalTo: self.gridRunLabel.bottomAnchor, constant: Dimensions.verticalSpacing20 * 1.5),
            self.createRoomButton.leadingAnchor.constraint(equalTo: self.joinRoomButton.trailingAnchor, constant: 20)
        ])
    }
    
    private func setupScrollView() {
        self.view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.joinRoomButton.bottomAnchor, constant: Dimensions.verticalSpacing20 * 1.5),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.versionLabel.topAnchor, constant: -Dimensions.verticalSpacing20)
        ])
        
        self.scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: Dimensions.verticalSpacing20),
            self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20),
            self.stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -20),
            self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -Dimensions.verticalSpacing20)
        ])
        
        self.stackView.addArrangedSubview(quickPlayView)
        self.stackView.addArrangedSubview(rankedPlayView)
    }
    
    private func setupVersionLabel() {
        self.versionLabel.setup(in: self.view)
        
        NSLayoutConstraint.activate([
            self.versionLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            self.versionLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
}
