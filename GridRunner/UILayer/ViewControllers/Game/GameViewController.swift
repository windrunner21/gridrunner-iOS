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
        let map = Map(with: MapDimensions(13, by: 13))
        self.game.createSession(
            with: map,
            for: Runner(at: map.getCenterCoordinates())
        )
        
        // If player could not have been instatiated return.
        // TODO: replace with error screen later
        guard let player = game.getPlayer() else { return }
        
        // Prepare game grid.
        self.createGameGrid(
            rows: game.getMap().getDimensions().getNumberOfRows(),
            columns: game.getMap().getDimensions().getNumberOfColumns(),
            inside: gameView
        )
        
        self.setUpOptionsButton()
        self.updateMovesLabel(with: player.numberOfMoves)
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
        
        self.optionsButton.menu = UIMenu(children: [
            UIAction(title: "Main Menu", state: .off, handler: mainMenuClosure)
        ])
        
        self.optionsButton.showsMenuAsPrimaryAction = true
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
                
                tile.position = Coordinate(x: row, y: column)
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
        guard let player = game.getPlayer() else { return }
        
        switch tile.type {
        case .start:
            self.startTileTapped(tile)
        case .exit:
            self.exitTileTapped(tile)
        default:
            if player.numberOfMoves > 0 { basicTileTapped(tile, by: player) }
        }
    }
    
    private func startTileTapped(_ tile: Tile) {
        print("Start tile with id: \(tile.getIdentifier()) tapped.")
    }
    
    private func exitTileTapped(_ tile: Tile) {
        print("Exit tile with id: \(tile.getIdentifier()) tapped.")
    }
    
    private func basicTileTapped(_ tile: Tile, by player: Player) {
        print("Basic tile with id: \(tile.getIdentifier()) tapped. (Tile open: \(tile.isOpen()).")
        
        if let player = player as? Runner {
            let allowedMove = game.canRunnerMoveBeAllowed(from: player.position, to: tile.position)
            let direction: MoveDirection = game.identifyRunnerMovingDirection(from: player.position, to: tile.position)
            
            if allowedMove && direction != .unknown {
                player.move(to: tile.position)
                tile.setDirectionImage(to: direction)
                tile.backgroundColor = .systemIndigo.withAlphaComponent(0.5)
                tile.open()
            } else {
                print("Forbidden move.")
            }
        }
        
        self.updateMovesLabel(with: player.numberOfMoves)
    }
    
    private func updateMovesLabel(with value: Int) {
        self.movesLabel.text = "\(value) moves left"
    }
}
