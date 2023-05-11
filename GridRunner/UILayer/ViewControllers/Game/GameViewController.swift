//
//  GameViewController.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 07.05.23.
//

import UIKit

class GameViewController: UIViewController {
    
    // Storyboard properties.
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var gameView: UIView!
    
    @IBOutlet weak var optionsButton: UIButton!
    
    // Controller related temporary properties. TODO: remove into business logic
    let numberOfRows: Int = Int.random(in: 9...15)
    var numberOfColumns: Int {
        numberOfRows
    }
    var playerType: PlayerType = .runner
    var moves: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Update moves label when loading the view.
        moves = playerType == .runner ? 2 : 1
        movesLabel.text = "\(moves) moves left"
        
        // Set up game options.
        setUpOptionsButton()
        
        // Prepare game grid.
        createGameGridWithDimensions(numberOfRows, by: numberOfColumns, inside: gameView)
    }
    
    @IBAction func onFinish(_ sender: Any) {
        if moves > 0 {
            moves -= 1
            
            movesLabel.text = "\(moves) moves left"
        }
    }
    
    private func setUpOptionsButton() {
        
        let mainMenuClosure = {(action: UIAction) in
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
            let mainViewController: UIViewController = mainStoryboard.instantiateViewController(identifier: "MainScreen") as MainViewController
            
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            sceneDelegate?.transitionViewController.transition(to: mainViewController, with: [.transitionCurlDown])
        }
        
        optionsButton.menu = UIMenu(children: [
            UIAction(title: "Main Menu", state: .off, handler: mainMenuClosure)
        ])
        
        optionsButton.showsMenuAsPrimaryAction = true
    }
    
    private func createGameGridWithDimensions(_ rows: Int, by columns: Int, inside rootView: UIView, spacing: CGFloat = 5) {
        
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fillEqually
        verticalStackView.spacing = spacing
        
        for row in 0..<rows {
            let horizontalStackView = UIStackView()
            horizontalStackView.axis = .horizontal
            horizontalStackView.alignment = .fill
            horizontalStackView.distribution = .fillEqually
            horizontalStackView.spacing = spacing
            
            for column in 0..<columns {
                let button = UIButton()
                initializeMap(for: button, row, column)
                button.layer.cornerRadius = 6
                button.addTarget(self, action: #selector(gridButtonClicked), for: .touchUpInside)
                horizontalStackView.addArrangedSubview(button)
            }
            verticalStackView.addArrangedSubview(horizontalStackView)
        }
        
        rootView.addSubview(verticalStackView)
        
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.topAnchor.constraint(equalTo: rootView.topAnchor, constant: 0).isActive = true
        verticalStackView.rightAnchor.constraint(equalTo: rootView.rightAnchor, constant: 0).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: rootView.bottomAnchor, constant: 0).isActive = true
        verticalStackView.leftAnchor.constraint(equalTo: rootView.leftAnchor, constant: 0).isActive = true
    }
    
    private func initializeMap(for button: UIButton, _ row: Int, _ column: Int) {
        //let numberOfExits = Int.random(in: 1...4)
        
        if row == 0 && column == 0 {
            button.backgroundColor = .systemMint
        } else if row == numberOfRows / 2 && column == numberOfColumns / 2 {
            button.backgroundColor = .systemIndigo
        } else if row == numberOfRows - 1 && column == numberOfColumns - 1 {
            button.backgroundColor = .systemMint
        } else {
            button.backgroundColor = .systemGray3
        }
    }
    
    @objc func gridButtonClicked(_ button: UIButton) {
        button.backgroundColor = .systemRed
        print("i'm clicked")
    }
}
