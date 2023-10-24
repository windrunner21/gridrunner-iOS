//
//  LoadingViewController.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 21.10.23.
//

import UIKit

class LoadingViewController: UIViewController {
    
    var joining: Bool!
    private let alertAdapter = AlertAdapter()
    private var hintsIndex: Int = 0
    private weak var hintsTimer: Timer?
    
    // Programmable UI properties.
    private let backgroundContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "Red")
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Entering game"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Kanit-Medium", size: Dimensions.titleFont)
        label.textColor = .white
        return label
    }()
    
    private let hintsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Kanit-Regular", size: Dimensions.subtitleFont)
        label.textColor = UIColor(named: "Black")
        label.textAlignment = .center
        label.numberOfLines = 3
        return label
    }()
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "Background")
        
        self.setupBackgroundContainerView()
        self.setupContainerSubViews()
        self.setupHints()
        
        self.startHintTimer()
        
        AblyService.shared.enterGame(joining: self.joining)
        
        NotificationCenter.default.addObserver(self, selector: #selector(transitionToGame), name: NSNotification.Name("Success:GameConfig"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentGameOverAlert), name: NSNotification.Name("Success:GameOver"), object: nil)
    }
    
    @objc private func transitionToGame() {
        let gameViewController: GameViewController = GameViewController()
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.transitionViewController.transition(to: gameViewController, with: [.transitionCurlUp])
    }
    
    @objc private func presentGameOverAlert() {
        let alert = alertAdapter.createGameOverAlert(winner: GameOver.shared.getWinner(), reason: GameOver.shared.reason, alertActionHandler: { [weak self] in
            self?._transitionToMainScreen()
        })
        
        self.present(alert, animated: true)
    }
    
    private func setupBackgroundContainerView() {
        self.view.addSubview(self.backgroundContainerView)
    
        NSLayoutConstraint.activate([
            self.backgroundContainerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.backgroundContainerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.backgroundContainerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            self.backgroundContainerView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 3)
        ])
    }
    
    private func setupContainerSubViews() {
        self.setupActivityIndicator()
        
        self.view.addSubview(self.titleLabel)
        
        NSLayoutConstraint.activate([
            self.titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.titleLabel.topAnchor.constraint(equalTo: self.activityIndicator.bottomAnchor, constant: Dimensions.verticalSpacing20)
        ])
    }
    
    private func setupActivityIndicator() {
        self.activityIndicator.color = .white
        self.activityIndicator.startAnimating()
        self.activityIndicator.center = self.view.center
        self.view.addSubview(self.activityIndicator)
    }
    
    private func setupHints() {
        self.view.addSubview(hintsLabel)
                
        hintsLabel.text = "⚠️ \(GameHints.hints[hintsIndex])"
        hintsIndex += 1
        
        NSLayoutConstraint.activate([
            self.hintsLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.hintsLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.hintsLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.hintsLabel.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func startHintTimer() {
        self.hintsTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
            self?.updateHintsLabel()
        }
    }
    
    private func updateHintsLabel() {
        hintsLabel.text = "⚠️ \(GameHints.hints[hintsIndex])"
        hintsIndex = (hintsIndex + 1) % GameHints.hints.count
    }
    
    private func _transitionToMainScreen() {
        AblyService.shared.leaveGame()
        let mainViewController: MainViewController = MainViewController()
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.transitionViewController.transition(to: mainViewController, with: [.transitionCurlDown])
    }
}
