//
//  ErrorAlert.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 07.06.23.
//

import UIKit

class AlertAdapter {
    func createGameOverAlert(winner: PlayerType, reason: String? = nil ,alertActionHandler: @escaping () -> Void) -> UIAlertController {
        
        let player = winner == .runner ? "Runner" : "Seeker"
        let opponent = winner == .runner ? "Seeker" : "Runner"
        
        var message: String = "Congratulations to \(player)!\n\(player) wins. "
        
        if let reason = reason, reason == "resign" {
            message += "\n\(opponent) has resigned from the game."
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
                title: "OK",
                style: .default,
                handler: { _ in
                    actionSheet.dismiss(animated: true)
                }
            )
        )
        
        return actionSheet
    }
}
