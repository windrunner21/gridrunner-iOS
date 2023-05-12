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
    
    // Controller properties.
    var game = Game()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Prepare game class.
        game.createSession(
            with: Map(with: MapDimensions(13, by: 13)),
            for: Runner()
        )
        
        // Prepare game grid.
        createGameGrid(
            rows: game.getMap().getDimensions().getNumberOfRows(),
            columns: game.getMap().getDimensions().getNumberOfColumns(),
            inside: gameView
        )
        
        movesLabel.text = "\(game.getPlayer()?.numberOfMoves ?? -1) moves left"
        
        setUpOptionsButton()
    }
    
    @IBAction func onUndo(_ sender: Any) {
    }
    
    @IBAction func onFinish(_ sender: Any) {
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
    
    private func createGameGrid(rows: Int, columns: Int, inside rootView: UIView, spacing: CGFloat = 5) {
        
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
                let tile = Tile()
                tile.setIdentifier("\(row)\(column)")
                decorateTile(tile, at: row, and: column)
                tile.layer.cornerRadius = 6
                tile.addTarget(self, action: #selector(gridButtonClicked), for: .touchUpInside)
                horizontalStackView.addArrangedSubview(tile)
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
    
    private func decorateTile(_ tile: Tile, at row: Int, and column: Int) {
        if row == 0 && column == 0 {
            tile.type = .exit
            tile.backgroundColor = .systemMint
        } else if row == game.getMap().getDimensions().getNumberOfRows() / 2 &&
                  column == game.getMap().getDimensions().getNumberOfColumns() / 2 {
            tile.type = .start
            tile.backgroundColor = .systemIndigo
        } else if row == game.getMap().getDimensions().getNumberOfRows() - 1 &&
                  column == game.getMap().getDimensions().getNumberOfColumns() - 1 {
            tile.type = .exit
            tile.backgroundColor = .systemMint
        } else {
            tile.type = .basic
            tile.backgroundColor = .systemGray3
        }
    }
    
    @objc func gridButtonClicked(_ tile: Tile) {
        print("oldValue for tile with id \(tile.getIdentifier()) is \(tile.isOpen())")
        if tile.type == .basic {
            tile.backgroundColor = .systemIndigo.withAlphaComponent(0.5)
            tile.open()
        }
        print("new for tile with id \(tile.getIdentifier()) is \(tile.isOpen())")
    }
}
