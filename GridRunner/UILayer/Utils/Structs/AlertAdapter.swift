//
//  ErrorAlert.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 07.06.23.
//

import UIKit

class AlertAdapter {
    
    func createInfoAlert() -> UIAlertController {
        
        let info: String = "Gridrun is a turn based strategy game played on a random sized grid. Player can be assigned one of the two roles: Runner or Seeker.\n\nRunner: The goal of the Runner is to reach the exit tile before the Seeker finds them. Runner can move only LEFT, UP, RIGHT, DOWN.\n\nSeeker: The goal fo the Seeker is to find the Runner before they can escape. Seeker can move anywhere."
        
        let alert = UIAlertController(title: "Game Info", message: info, preferredStyle: .alert)
        
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: { _ in
                    alert.dismiss(animated: true)
                }
            )
        )
        
        return alert
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
        
        alert.addAction(
            UIAlertAction(
                title: NSLocalizedString("Try again", comment: "Default action"),
                style: .default,
                handler: { _ in
                    alert.dismiss(animated: true)
                }
            )
        )
        
        return alert
    }
    
    func createServiceRequestErrorAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Error.", message: "Something went wrong. Check your credentials.", preferredStyle: .alert)
        
        alert.addAction(
            UIAlertAction(
                title: NSLocalizedString("OK", comment: "Default action"),
                style: .default,
                handler: { _ in
                    alert.dismiss(animated: true)
                }
            )
        )
        
        return alert
    }
    
    func createDecoderErrorAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Oh no.", message: "Something went wrong. Please try again.", preferredStyle: .alert)
        
        alert.addAction(
            UIAlertAction(
                title: NSLocalizedString("OK", comment: "Default action"),
                style: .default,
                handler: { _ in
                    alert.dismiss(animated: true)
                }
            )
       )
        
        return alert
    }
    
    func createEnterRoomAlert() -> UIAlertController {
        let actionSheet = UIAlertController(title: "Enter room code", message: "Need to enter room code", preferredStyle: .actionSheet)
        
        actionSheet.addAction(
            UIAlertAction(
                title: NSLocalizedString("OK", comment: "Default action"),
                style: .default,
                handler: { _ in
                    actionSheet.dismiss(animated: true)
                }
            )
        )
        
        return actionSheet
    }
    
    func createCheckEmailAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Email sent!", message: "Password reset link has been successfully sent to the email address you provided.", preferredStyle: .alert)
        
        alert.addAction(
            UIAlertAction(
                title: NSLocalizedString("OK", comment: "Default action"),
                style: .default,
                handler: { _ in
                    alert.dismiss(animated: true)
                }
            )
        )
                        
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
