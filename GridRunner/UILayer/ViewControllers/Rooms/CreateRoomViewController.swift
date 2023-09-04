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
    
    @IBOutlet weak var cancelView: UIView!
    
    @IBOutlet weak var rolePopUpButton: UIButton!
    
    @IBOutlet weak var createRoomButton: UIButton!
    @IBOutlet weak var joinRoomButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createRoomButton.setup()
        
        self.setupRolePopUp()
        
        // Close current view, dismiss with animation, on cancel view tap.
        let cancelViewTap = UITapGestureRecognizer(target: self, action: #selector(closeView))
        self.cancelView.addGestureRecognizer(cancelViewTap)
    }
    
    @objc func closeView() {
        self.mainViewController.dismiss(animated: true)
    }
    
    private func setupRolePopUp() {
        self.currentRole = .runner
        
        self.rolePopUpButton.menu = UIMenu(children: [
            UIAction(title: "Runner", handler: {_ in
                self.currentRole = .runner
            }),
            UIAction(title: "Seeker", handler: {_ in
                self.currentRole = .seeker
            }),
            UIAction(title: "Random", handler: {_ in
                self.currentRole = .random
            })
        ])
    }
    
    
    @IBAction func onJoinRoom(_ sender: Any) {
        let joinRoomStoryboard: UIStoryboard = UIStoryboard(name: "JoinRoom", bundle: .main)
        let joinRoomViewController: JoinRoomViewController = joinRoomStoryboard.instantiateViewController(identifier: "JoinRoomScreen")
        
        joinRoomViewController.mainViewController = self.mainViewController
        
        self.present(joinRoomViewController, animated: true)
    }
    
    @IBAction func onCreateRoomTouchDown(_ sender: Any) {
        self.createRoomButton.onTouchDown()
    }
    
    @IBAction func onCreateRoomTouchUpOutside(_ sender: Any) {
        self.createRoomButton.onTouchUpOutside()
    }
    
    @IBAction func onCreateRoom(_ sender: Any) {
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
}
