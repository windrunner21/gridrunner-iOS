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
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
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
        NSLog("Game has been instantiated.")
        
        // MARK: For Seeker gameplay testing purposes.
//        self.game.createSession(
//            with: map,
//            for: Runner(at: map.getCenterCoordinates()),
//            with: GameHistory(
//                runnerHistory: [
//                    Coordinate(x: 6, y: 6),
//                    Coordinate(x: 6, y: 5),
//                    Coordinate(x: 6, y: 4),
//                    Coordinate(x: 6, y: 3),
//                    Coordinate(x: 6, y: 2),
//                    Coordinate(x: 5, y: 2),
//                    Coordinate(x: 4, y: 2),
//                    Coordinate(x: 4, y: 3),
//                    Coordinate(x: 4, y: 4),
//                    Coordinate(x: 5, y: 4),
//                    Coordinate(x: 6, y: 4),
//                    Coordinate(x: 7, y: 4),
//                    Coordinate(x: 8, y: 4)],
//                seekerHistory: [])
//        )
        
        // If player could not have been instatiated return.
        guard let player = game.getPlayer() else {
            self.presentErrorAlert()
            return
        }
        
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
        guard let player = game.getPlayer() else { return }
        guard let coordinatesToClear = player.movesHistory.last else { return }
        
        player.undo()
        self.updateMovesLabel(with: player.numberOfMoves)
        let tile = self.accessTile(with: coordinatesToClear, in: gameView)
        tile?.close()
        
        if let player = player as? Runner {
            self.runnerClickedUndo(player)
        }
        
        self.undoButton.isEnabled = player.numberOfMoves != player.maximumNumberOfMoves
        self.finishButton.isEnabled = player.numberOfMoves != player.maximumNumberOfMoves
    }
    
    @IBAction func onFinish(_ sender: Any) {
        guard let player = game.getPlayer() else { return }
        
        if player.didWin {
            NSLog("Game has been concluded.")
            self.presentWinAlert()
        } else {
            player.incrementNumberOfMoves()
            // TODO: Update maximum number of moves at correct place, take into account power ups.
            player.updateMaximumNumberOfMoves(to: 1)
            self.updateMovesLabel(with: player.numberOfMoves)
        }
        
        self.undoButton.isEnabled = false
        self.finishButton.isEnabled = false
    }
    
    private func setUpOptionsButton() {
        let mainMenuClosure = {(action: UIAction) in
            self.transitionToMainScreen()
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
                tile.setupTile(at: row, and: column, with: game.getMap().getDimensions())
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
    
    @objc func gridButtonClicked(_ tile: Tile) {
        guard let player = game.getPlayer() else { return }
        
        switch tile.type {
        case .start:
            self.startTileTapped(tile)
        case .exit:
            self.exitTileTapped(tile, by: player)
        default:
            if player.numberOfMoves > 0 { basicTileTapped(tile, by: player) }
        }
        
    }
    
    private func startTileTapped(_ tile: Tile) {
        print("Start tile with id: \(tile.getIdentifier()) tapped.")
    }
    
    private func exitTileTapped(_ tile: Tile, by player: Player) {
        if let player = player as? Runner {
            self.runnerTappedTile(runner: player, tile: tile, isExitTile: true)
        }
        
        self.updateMovesLabel(with: player.numberOfMoves)

        // Handle enabling finish button.
        self.enableFinishButton(on: player.numberOfMoves == 0)
    }
    
    private func basicTileTapped(_ tile: Tile, by player: Player) {
        print("Basic tile with id: \(tile.getIdentifier()) tapped. (Tile open: \(tile.isOpen()).)")
        
        if let player = player as? Runner {
            self.runnerTappedTile(runner: player, tile: tile)
        }
        
        self.updateMovesLabel(with: player.numberOfMoves)
        
        // Handle enabling finish and undo buttons.
        self.enableUndoButton(on: player.numberOfMoves < player.maximumNumberOfMoves)
        self.enableFinishButton(on: player.numberOfMoves == 0)
        print(player.movesHistory)
    }
    
    private func runnerClickedUndo(_ runner: Runner) {
        if let coordinatesToUpdate = runner.movesHistory.last {
            let tile = self.accessTile(with: coordinatesToUpdate, in: gameView)
            guard let direction = runner.getHistoryWithDirections()[coordinatesToUpdate] else { return }
            tile?.updateDirectionImageOnUndo(to: direction)
        }
    }
    
    private func runnerTappedTile(runner: Runner, tile: Tile, isExitTile: Bool? = nil) {
        let allowedMove = runner.canMoveBeAllowed(from: runner.position, to: tile.position)
        let direction: MoveDirection = runner.identifyMovingDirection(from: runner.position, to: tile.position)
        
        // Manage previous tile arrow direction if previous tile exists.
        var previousDirection: MoveDirection? = nil
        let previousTile = self.accessTile(with: runner.position, in: gameView)
        if let previousTile = previousTile {
            previousDirection = runner.getHistoryWithDirections()[previousTile.position]
        }
        
        if allowedMove && direction != .unknown {
            runner.move(to: tile.position)
            runner.updateHistoryWithDirections(at: tile.position, moving: direction)
            
            tile.open()
            tile.updateDirectionImage(to: direction, from: previousDirection, oldTile: previousTile)
            
            game.getHistory()?.updateRunnerHistory(with: runner.movesHistory)
            
            if let isExitTile = isExitTile, isExitTile {
                runner.win()
            }
        } else {
            print("Forbidden move for Runner.")
        }
    }
    
    private func accessTile(with coordinates: Coordinate, in view: UIView) -> Tile? {
        let row = coordinates.x
        let column = coordinates.y
        
        if let view = view.subviews.first as? UIStackView {
            if let row = view.arrangedSubviews[row] as? UIStackView {
                if let tile = row.arrangedSubviews[column] as? Tile {
                    print("Coordinates given: \(coordinates). (Tile open: \(tile.isOpen()).)")
                    return tile
                }
            }
        }
        
        return nil
    }
    
    private func updateMovesLabel(with value: Int) {
        self.movesLabel.text = "\(value) moves left"
    }
    
    private func enableUndoButton(on condition: Bool? = nil) {
        if let condition = condition {
            self.undoButton.isEnabled = condition
        } else {
            self.undoButton.isEnabled = true
        }
    }
    
    private func enableFinishButton(on condition: Bool? = nil) {
        if let condition = condition {
            self.finishButton.isEnabled = condition
        } else {
            self.finishButton.isEnabled = true
        }
    }
    
    private func presentWinAlert() {
        let alert = UIAlertController(title: "Game Over", message: "Congratulations! You have won.", preferredStyle: .alert)
        
        alert.addAction(
            UIAlertAction(
                title: NSLocalizedString("Main Menu", comment: "Default action"),
                style: .default,
                handler: { _ in
                    self.transitionToMainScreen()
                }
            )
        )
        
        self.present(alert, animated: true)
    }
    
    private func presentErrorAlert() {
        let alert = UIAlertController(title: "Oops.", message: "Something went wrong. Please try again.", preferredStyle: .alert)
        
        alert.addAction(
            UIAlertAction(
                title: NSLocalizedString("Main Menu", comment: "Default action"),
                style: .default,
                handler: { _ in
                    self.transitionToMainScreen()
                }
            )
        )
        
        self.present(alert, animated: true)
    }
    
    private func transitionToMainScreen() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
        let mainViewController: UIViewController = mainStoryboard.instantiateViewController(identifier: "MainScreen") as MainViewController
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.transitionViewController.transition(to: mainViewController, with: [.transitionCurlDown])
    }
}
