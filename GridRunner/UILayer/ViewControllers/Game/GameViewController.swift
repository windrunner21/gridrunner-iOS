//
//  GameViewController.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 07.05.23.
//

import UIKit

class GameViewController: UIViewController {

    // Override device orienation settings.
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeRight
    }
    
    // Storyboard properties.
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var movesLabel: UILabel!
    
    // Controller related temporary properties.
    var playerType: PlayerType = .runner
    var moves: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Update moves label when loading the view.
        moves = playerType == .runner ? 2 : 1
        movesLabel.text = "\(moves) moves left"
    }
    
    @IBAction func onFinish(_ sender: Any) {
        if moves > 0 {
            moves -= 1
            
            movesLabel.text = "\(moves) moves left"
        }
    }
}
