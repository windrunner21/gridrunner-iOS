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
        
        self.cancelView.transformToCircle()
        self.createRoomButton.setup()
        
        self.setupRolePopUp()
        
        // Adding elevation/shadow to cancel view
        self.cancelView.addButtonElevation()
        
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
    
    @IBAction func onCreateRoom(_ sender: Any) {
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
                
                
                AblyService.shared.update(with: token)
                
                print(token)
                guard let clientId = AblyService.shared.getClientId() else {
                    DispatchQueue.main.async {
                        let alert = self.alertAdapter.createNetworkErrorAlert()
                        self.present(alert, animated: true)
                    }
                    return
                }
                print(clientId)
                GameService().createRoom(as: self.currentRole.value, withId: clientId) { response in
                    switch response {
                    case .success:
                        print("success")
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
