//
//  RoomLoadingViewController.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 21.10.23.
//

import UIKit

class RoomLoadingViewController: UIViewController {

    let alertAdapter = AlertAdapter()
    
    // Programmable UI properties.
    private let roomCodeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = GameSessionDetails.shared.roomCode
        label.font = UIFont(name: "Kanit-Medium", size: Dimensions.subtitleFont)
        label.textColor = UIColor(named: "Black")
        return label
    }()
    
    private let cancelView: CancelView = CancelView()
    let viewTitle: TitleLabel = TitleLabel()
    let viewSubtitle: SubtitleLabel = SubtitleLabel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let copyRoomCodeButton: PrimaryButton = PrimaryButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(named: "Background")
        
        self.cancelView.setup(in: self.view)
        self.setupViewLabels()
        self.setupActivityIndicator()
        self.setupRoomCodeLabel()
        self.setupCopyRoomCodeButton()
        
        // Close current view, dismiss with animation, on cancel view tap.
        let cancelViewTap = UITapGestureRecognizer(target: self, action: #selector(closeView))
        self.cancelView.addGestureRecognizer(cancelViewTap)
        
        AblyService.shared.enterGame(joining: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(transitionToGame), name: NSNotification.Name("Success:GameConfig"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentGameOverAlert), name: NSNotification.Name("Success:GameOver"), object: nil)
    }
    
    @objc func transitionToGame() {
        let gameViewController: GameViewController = GameViewController()
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.transitionViewController.transition(to: gameViewController, with: [.transitionCurlUp])
    }
    
    @objc private func presentGameOverAlert() {
        let alert = alertAdapter.createGameOverAlert(winner: GameOver.shared.getWinner(), reason: GameOver.shared.reason, alertActionHandler: { [weak self] in
            self?.transitionToMainScreen()
        })
        
        self.present(alert, animated: true)
    }
    
    @objc func closeView() {
        self.transitionToMainScreen()
    }
    
    @objc func onCopyTouchDown() {
        self.copyRoomCodeButton.onTouchDown()
    }
    
    @objc func onCopyTouchUpOutside() {
        self.copyRoomCodeButton.onTouchUpOutside()
    }
    
    @objc func onCopy() {
        guard let code = roomCodeLabel.text else { return }
        
        self.copyRoomCodeButton.disable()
        
        // Creating deep link.
        let url = URL(string:"https://gridrun.live/room?room=\(code)")
 
        let pasteboardString = "You have been invited to a game of GridRun. Click \(url!.absoluteString) to join your friend!"
        
        let pasteboard = UIPasteboard.general
        pasteboard.string = pasteboardString
        
        self.copyRoomCodeButton.enable()
    }
    
    private func setupViewLabels() {
        self.viewTitle.setup(in: self.view, as: "Waiting for 2nd Player 🕑")
        self.viewSubtitle.setup(in: self.view, as: "share the room code below with your friend and wait for them to enter the game")
        
        NSLayoutConstraint.activate([
            self.viewTitle.topAnchor.constraint(equalTo: self.cancelView.bottomAnchor, constant: Dimensions.verticalSpacing20),
            self.viewTitle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.viewTitle.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            self.viewSubtitle.topAnchor.constraint(equalTo: self.viewTitle.bottomAnchor),
            self.viewSubtitle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.viewSubtitle.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
        ])
    }
    
    private func setupActivityIndicator() {
        self.activityIndicator.color = UIColor(named: "Black")
        self.activityIndicator.startAnimating()
        self.activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
    }
    
    private func setupRoomCodeLabel() {
        self.view.addSubview(self.roomCodeLabel)
        
        NSLayoutConstraint.activate([
            self.roomCodeLabel.topAnchor.constraint(equalTo: self.activityIndicator.bottomAnchor, constant: Dimensions.verticalSpacing20),
            self.roomCodeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    private func setupCopyRoomCodeButton() {
        self.copyRoomCodeButton.width = Dimensions.buttonWidth * 1.5
        self.copyRoomCodeButton.height = self.copyRoomCodeButton.width / 4
        self.copyRoomCodeButton.setup(in: self.view, withTitle: "Copy code")
        
        self.copyRoomCodeButton.addTarget(self, action: #selector(onCopy), for: .touchUpInside)
        self.copyRoomCodeButton.addTarget(self, action: #selector(onCopyTouchDown), for: .touchDown)
        self.copyRoomCodeButton.addTarget(self, action: #selector(onCopyTouchUpOutside), for: .touchUpOutside)

        NSLayoutConstraint.activate([
            self.copyRoomCodeButton.topAnchor.constraint(equalTo: self.roomCodeLabel.bottomAnchor, constant: Dimensions.verticalSpacing20),
            self.copyRoomCodeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    private func transitionToMainScreen() {
        AblyService.shared.leaveGame()
        let mainViewController: MainViewController = MainViewController()
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.transitionViewController.transition(to: mainViewController, with: [.transitionCurlDown])
    }
}
