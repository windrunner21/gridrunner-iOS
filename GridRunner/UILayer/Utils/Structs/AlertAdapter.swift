//
//  ErrorAlert.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 07.06.23.
//

import UIKit

class AlertAdapter {
    private var joinRoomAlert: UIAlertController?
    
    @objc func codeDidChange() {
        guard let text = joinRoomAlert?.textFields?.first?.text else { return }
        joinRoomAlert?.actions[1].isEnabled = text.count > 14
    }
    
    func createJoinRoomAlert(loadingOverlayView: LoadingOverlayView,completion: @escaping (UIAlertController?, Response) -> Void) -> UIAlertController {
        self.joinRoomAlert = UIAlertController(title: "Join Room", message: nil, preferredStyle: .alert)
        
        self.joinRoomAlert?.addTextField { (textField) in
            textField.placeholder = "Enter room code"
            textField.returnKeyType = .done
            textField.keyboardType = .namePhonePad
            textField.addTarget(self, action: #selector(self.codeDidChange), for: .editingChanged)
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .default, handler: { _ in
            UIView.animate(withDuration: 0.3, animations: {
                loadingOverlayView.removeFromSuperview()
            })
        })
        
        let joinAction = UIAlertAction(
            title: NSLocalizedString("Join", comment: "Default action"),
            style: .default,
            handler: { _ in
                loadingOverlayView.load()
                
                if let textField = self.joinRoomAlert?.textFields?.first {
                    guard let roomCode = textField.text else {
                        completion(self.createNetworkErrorAlert(), .networkError)
                        return
                    }
                    
                    GameSessionDetails.shared.setRoomCode(to: roomCode)
                    
                    AblyJWTService().getJWT() { response, token in
                        switch response {
                        case .success:
                            guard let token = token else {
                                DispatchQueue.main.async {
                                    completion(self.createNetworkErrorAlert(), .networkError)
                                }
                                return
                            }
                            
                            AblyService.shared.update(with: token) { response, clientId in
                                switch response {
                                case .success:
                                    guard let _ = clientId else {
                                        DispatchQueue.main.async {
                                            completion(self.createNetworkErrorAlert(), .networkError)
                                        }
                                        return
                                    }
                                    
                                    GameService().joinRoom(withCode: roomCode) { response in
                                        switch response {
                                        case .success:
                                            DispatchQueue.main.async {
                                                completion(nil, .success)
                                            }
                                        case .networkError:
                                            DispatchQueue.main.async {
                                                completion(self.createNetworkErrorAlert(), .networkError)
                                            }
                                        case .requestError:
                                            DispatchQueue.main.async {
                                                completion(self.createServiceRequestErrorAlert(), .requestError)
                                            }
                                        case .decoderError:
                                            DispatchQueue.main.async {
                                                completion(self.createDecoderErrorAlert(), .decoderError)
                                            }
                                        }
                                    }
                                default:
                                    DispatchQueue.main.async {
                                        completion(self.createNetworkErrorAlert(), .networkError)
                                    }
                                }
                            }
                        case .requestError:
                            DispatchQueue.main.async {
                                completion(self.createServiceRequestErrorAlert(), .requestError)
                            }
                        default:
                            DispatchQueue.main.async {
                                completion(self.createNetworkErrorAlert(), .networkError)
                            }
                        }
                    }
                }
            }
        )
        
        self.joinRoomAlert?.addAction(cancelAction)
        self.joinRoomAlert?.addAction(joinAction)
        
        joinAction.isEnabled = false
        
        return self.joinRoomAlert!
    }
    
    func createGameOverAlert(winner: PlayerType, reason: String? = nil ,alertActionHandler: @escaping () -> Void) -> UIAlertController {
        
        var player: String = String()
        var opponent: String = String()
        var message: String = String()
        
        switch winner {
        case .runner:
            player = "Runner"
            opponent = "Seeker"
            message = "Congratulations to \(player)!\n\(player) wins. "
        case .seeker:
            player = "Seeker"
            opponent = "Runner"
            message = "Congratulations to \(player)!\n\(player) wins. "
        case .server:
            player = "No one"
            opponent = "No one"
            message = "Game closed. "
        }
        
        if let reason = reason, reason == "resign" {
            message += "\n\(opponent) has resigned from the game. "
        }
        
        if let reason = reason, reason == "timeout" {
            message += " Due to reaching timeout limit."
        }
        
        let alert = UIAlertController(title: "Game Over", message: message, preferredStyle: .alert)
        
        alert.addAction(
            UIAlertAction(
                title: NSLocalizedString("Return to Menu", comment: "Default action"),
                style: .default,
                handler: { _ in
                    alertActionHandler()
                }
            )
        )
        
        return alert
    }
    
    func createGameErrorAlert(alertActionHandler: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(title: "Oops.", message: "Something went wrong. Please try again.", preferredStyle: .alert)
        
        alert.addAction(
            UIAlertAction(
                title: NSLocalizedString("Main Menu", comment: "Default action"),
                style: .default,
                handler: { _ in
                    alertActionHandler()
                }
            )
        )
        
        return alert
    }
    
    func createNetworkErrorAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Network Error.", message: "Something went wrong. Please try later.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Try again", comment: "Default action"),style: .default))
        
        return alert
    }
    
    func createServiceRequestErrorAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Error.", message: "Something went wrong. Check your credentials.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
        
        return alert
    }
    
    func createDecoderErrorAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Oh no.", message: "Something went wrong. Please try again.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
    
        return alert
    }
    
    func createCheckEmailAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Email sent!", message: "Password reset link has been successfully sent to the email address you provided.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
        
        return alert
    }
    
    func createForceUpgradeAlert(completion: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(title: "Breaking API Changes", message: "Our new API contains major changes. Please update your application to avoid any unexpected errors.", preferredStyle: .alert)
        
        alert.addAction(
            UIAlertAction(
                title: NSLocalizedString("OK", comment: "Default action"),
                style: .default,
                handler: { _ in
                    alert.dismiss(animated: true) {
                        completion()
                    }
                }
            )
        )
        
        return alert
    }
}
