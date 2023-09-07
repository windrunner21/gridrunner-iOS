//
//  FriendlyViewController.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 17.07.23.
//

import UIKit

class CreateRoomViewController: UIViewController {
    
    var mainViewController: MainViewController!
    private let alertAdapter: AlertAdapter = AlertAdapter()
    private var currentRole: RoleType!
    
    // Programmable UI properties.
    let cancelView: CancelView = CancelView()
    let viewTitle: TitleLabel = TitleLabel()
    let viewSubtitle: SubtitleLabel = SubtitleLabel()
    
    // @IBOutlet weak var rolePopUpButton: UIButton!
    let createRoomButton: PrimaryButton = PrimaryButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: "Background")

        self.cancelView.setup(in: self.view)
        self.setupViewLabels()
        self.setupCreateRoomButtonButton()
        
        //self.setupRolePopUp()
        
        // Close current view, dismiss with animation, on cancel view tap.
        let cancelViewTap = UITapGestureRecognizer(target: self, action: #selector(closeView))
        self.cancelView.addGestureRecognizer(cancelViewTap)
    }
    
    @objc func closeView() {
        self.mainViewController.dismiss(animated: true)
    }
    
//    private func setupRolePopUp() {
//        self.currentRole = .runner
//
//        self.rolePopUpButton.menu = UIMenu(children: [
//            UIAction(title: "Runner", handler: {_ in
//                self.currentRole = .runner
//            }),
//            UIAction(title: "Seeker", handler: {_ in
//                self.currentRole = .seeker
//            }),
//            UIAction(title: "Random", handler: {_ in
//                self.currentRole = .random
//            })
//        ])
//    }
    
    @objc func onCreateRoomTouchDown() {
        self.createRoomButton.onTouchDown()
    }
    
    @objc func onCreateRoomTouchUpOutside() {
        self.createRoomButton.onTouchUpOutside()
    }
    
    @objc func onCreateRoom() {
        self.sendCreateRoomRequest()
    }
    
    private func sendCreateRoomRequest() {
        self.createRoomButton.disable()
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
            
                AblyService.shared.update(with: token) { response, clientId in
                    switch response {
                    case .success:
                        guard let clientId = clientId else {
                            DispatchQueue.main.async {
                                let alert = self.alertAdapter.createNetworkErrorAlert()
                                self.present(alert, animated: true)
                            }
                            return
                        }
                        
                        switch self.currentRole {
                        case .runner:
                            GameSessionDetails.shared.setRunner(to: clientId)
                        case .seeker:
                            GameSessionDetails.shared.setSeeker(to: clientId)
                        case .random:
                            let randomInt = Int.random(in: 0...100)
                            if randomInt > 50 {
                                GameSessionDetails.shared.setRunner(to: clientId)
                                self.currentRole = .runner
                            } else {
                                GameSessionDetails.shared.setSeeker(to: clientId)
                                self.currentRole = .seeker
                            }
                        case .none:
                            break
                        }
                    
                        GameService().createRoom(as: self.currentRole.value, withId: clientId) { response in
                            switch response {
                            case .success:
                                guard let roomCode = Friendly.shared.getRoomCode() else {
                                    DispatchQueue.main.async {
                                        let alert = self.alertAdapter.createDecoderErrorAlert()
                                        self.present(alert, animated: true)
                                    }
                                    return
                                }
                      
                                GameSessionDetails.shared.setRoomCode(to: roomCode)
                                DispatchQueue.main.async {
                                    self.createRoomButton.enable()
                                    self.mainViewController.dismiss(animated: true) {
                                        NotificationCenter.default.post(name: NSNotification.Name("Success::Matchmaking::Custom"), object: nil)
                                    }
                                }
                                
                            case .networkError:
                                DispatchQueue.main.async {
                                    let alert = self.alertAdapter.createNetworkErrorAlert()
                                    self.present(alert, animated: true)
                                }
                            case .requestError:
                                DispatchQueue.main.async {
                                    let alert = self.alertAdapter.createServiceRequestErrorAlert()
                                    self.present(alert, animated: true)
                                }
                            case .decoderError:
                                DispatchQueue.main.async {
                                    let alert = self.alertAdapter.createDecoderErrorAlert()
                                    self.present(alert, animated: true)
                                }
                            }
                        }
                    default:
                        DispatchQueue.main.async {
                            let alert = self.alertAdapter.createNetworkErrorAlert()
                            self.present(alert, animated: true)
                        }
                    }
                }
            case .requestError:
                DispatchQueue.main.async {
                    let alert = self.alertAdapter.createServiceRequestErrorAlert()
                    self.present(alert, animated: true)
                }
            default:
                DispatchQueue.main.async {
                    let alert = self.alertAdapter.createNetworkErrorAlert()
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    private func setupViewLabels() {
        self.viewTitle.setup(in: self.view, as: "Create custom room 🚪")
        self.viewSubtitle.setup(in: self.view, as: "make your own customizable game for yourself and your friends. more customization options are coming 🔜")
        
        NSLayoutConstraint.activate([
            self.viewTitle.topAnchor.constraint(equalTo: self.cancelView.bottomAnchor, constant: Dimensions.verticalSpacing20),
            self.viewTitle.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.viewTitle.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            self.viewSubtitle.topAnchor.constraint(equalTo: self.viewTitle.bottomAnchor),
            self.viewSubtitle.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.viewSubtitle.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    private func setupCreateRoomButtonButton() {
        self.createRoomButton.addTarget(self, action: #selector(onCreateRoom), for: .touchUpInside)
        self.createRoomButton.addTarget(self, action: #selector(onCreateRoomTouchUpOutside), for: .touchUpOutside)
        self.createRoomButton.addTarget(self, action: #selector(onCreateRoomTouchDown), for: .touchDown)
        
        self.createRoomButton.width = UIScreen.main.bounds.width - 40
        self.createRoomButton.height = self.createRoomButton.width / 8
        self.createRoomButton.setup(in: self.view, withTitle: "Create room")
        
        NSLayoutConstraint.activate([
            self.createRoomButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.createRoomButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.createRoomButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
}
