//
//  ErrorAlert.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 07.06.23.
//

import UIKit

class AlertAdapter {
    func createGameOverAlert(alertActionHandler: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(title: "Game Over.", message: "Congratulations! You have won.", preferredStyle: .alert)
        
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
}
