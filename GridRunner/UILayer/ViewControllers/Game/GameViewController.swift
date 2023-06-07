//
//  GameViewController.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 07.05.23.
//

import UIKit

class GameViewController: UIViewController {
    
    // Storyboard properties.
    @IBOutlet weak var playerTypeLabel: UILabel!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var emojiIconLabel: UILabel!
    @IBOutlet weak var againstEmojiIconLabel: UILabel!
    
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var emojiIconView: UIView!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var versusProfileView: UIView!
    @IBOutlet weak var versusEmojiIconView: UIView!
    
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    // Controller properties.
    var game = Game()
    var alertAdapter = AlertAdapter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCancelButton()
        self.initializeGame()
        self.decorateViews()
    }
    
    @objc private func cancel() {
        self.transitionToMainScreen()
    }
    
    @IBAction func onUndo(_ sender: Any) {
        guard let player = game.getPlayer() else {
            presentErrorAlert()
            return
        }
        
        guard let lastMove = player.history.last?.getMoves().last else {
            print("Could not get last move from Player. Returning...")
            presentErrorAlert()
            return
        }
        
        let lastTile = self.accessTile(with: lastMove.to, in: gameView)
        let previousTile = self.accessTile(with: lastMove.from, in: gameView)
        
        lastTile?.closeBy(player)
        
        player.undo(lastMove)
        
        if let runner = player as? Runner {
            runner.undo(previousTile: previousTile)
        }
        
        self.updateGameHUD(of: player)
    }
    
    @IBAction func onFinish(_ sender: Any) {
        guard let player = game.getPlayer() else {
            presentErrorAlert()
            return
        }
        
        guard let latestMove = player.history.last?.getMoves().last else { return }
        // Get clicked tile - the one player is currently standing on.
        guard let latestTile = self.accessTile(with: latestMove.to, in: gameView) else { return }
        
        player.finish()
        
        if let runner = player as? Runner {
            runner.finish(on: latestTile)
        }
        
        if let seeker = player as? Seeker {
            seeker.finish(on: latestTile, with: game.getHistory().getRunnerHistory())
        }
        
        if player.didWin {
            NSLog("Game has been concluded.")
            self.presentWinAlert()
        } else {
            self.updateMovesLabel(with: player.numberOfMoves)
        }
        
        self.undoButton.disable()
        self.finishButton.disable()
        
        player.outputHistory()
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
                tile.setupTile(at: row, and: column, with: game.getMap().getDimensions(), and: game.getHistory())

                let tileTap = UITapGestureRecognizer(target: self, action: #selector(tileTapped))
                tile.addGestureRecognizer(tileTap)
                
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
    
    @objc func tileTapped(_ sender: UITapGestureRecognizer) {
        guard let player = game.getPlayer() else {
            presentErrorAlert()
            return
        }
        
        guard let tile = sender.view as? Tile else  {
            presentErrorAlert()
            return
        }

        switch tile.type {
        case .start:
            self.startTileTapped(tile)
        case .exit:
            self.exitTileTapped(tile, by: player)
        default:
            self.basicTileTapped(tile, by: player)
        }
        
    }
    
    private func startTileTapped(_ tile: Tile) { }
    
    private func exitTileTapped(_ tile: Tile, by player: AnyPlayer) {
        if let runner = player as? Runner {
            let previousTile = self.accessTile(with: runner.position, in: gameView)
            runner.move(from: previousTile, to: tile)
            game.getHistory().setRunnerHistory(to: runner.history)
        }
        
        self.updateGameHUD(of: player)
    }
    
    private func basicTileTapped(_ tile: Tile, by player: AnyPlayer) {
        let previousTile = self.accessTile(with: player.position, in: gameView)
        
        player.move(from: previousTile, to: tile)
        game.getHistory().setHistory(of: player, to: player.history)
        
        self.updateGameHUD(of: player)
    }
    
    private func accessTile(with coordinates: Coordinate, in view: UIView) -> Tile? {
        let row = coordinates.x
        let column = coordinates.y
        
        if let view = view.subviews.first as? UIStackView {
            if let row = view.arrangedSubviews[row] as? UIStackView {
                if let tile = row.arrangedSubviews[column] as? Tile {
                    return tile
                }
            }
        }
        
        return nil
    }
    
    private func updateMovesLabel(with value: Int) {
        self.movesLabel.text = "\(value)"
    }
    
    private func enableUndoButton(on condition: Bool? = nil) {
        if let condition = condition, !condition {
            self.undoButton.disable()
        } else {
            self.undoButton.enable()
        }
    }
    
    private func enableFinishButton(on condition: Bool? = nil) {
        if let condition = condition, !condition {
            self.finishButton.disable()
        } else {
            self.finishButton.enable()
        }
    }
    
    private func updateGameHUD(of player: AnyPlayer) {
        self.updateMovesLabel(with: player.numberOfMoves)
        
        // Handle enabling finish and undo buttons.
        self.enableUndoButton(on: player.numberOfMoves < player.maximumNumberOfMoves)
        self.enableFinishButton(on: player.numberOfMoves == 0)
    }
    
    private func presentWinAlert() {
        let alert = alertAdapter.createGameOverAlert(alertActionHandler: { [weak self] in
            self?.transitionToMainScreen()
        })
        
        self.present(alert, animated: true)
    }
    
    private func presentErrorAlert() {
        let alert = alertAdapter.createGameErrorAlert(alertActionHandler: { [weak self] in
            self?.transitionToMainScreen()
        })
        
        self.present(alert, animated: true)
    }
    
    private func transitionToMainScreen() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: .main)
        let mainViewController: UIViewController = mainStoryboard.instantiateViewController(identifier: "MainScreen") as MainViewController
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.transitionViewController.transition(to: mainViewController, with: [.transitionCurlDown])
    }
    
    private func initializeGame() {
        // Prepare game class.
        let map = Map(with: MapDimensions(13, by: 13))
        
        let history = History(with: GameHistoryExamples().runnerHistory1, and: GameHistoryExamples().seekerHistory1)
        
        self.game.createSession(
            with: map,
            for: Runner(at: map.getCenterCoordinates()),
            with: history
        )
        
        NSLog("Game has been instantiated.")
        
        // If player could not have been instatiated return.
        guard let player = game.getPlayer() else {
            self.presentErrorAlert()
            return
        }
        
        // Game session always instantiated with history, populate history of players.
        switch game.getPlayer()?.type {
        case .runner:
            game.getPlayer()?.setHistory(to: game.getHistory().getRunnerHistory())
            game.getPlayer()?.updateCurrentTurn(to: game.getHistory().getRunnerHistory().count + 1)
        case .seeker:
            game.getPlayer()?.setHistory(to: game.getHistory().getSeekerHistory())
            game.getPlayer()?.updateCurrentTurn(to: game.getHistory().getSeekerHistory().count + 1)
        default:
            break
        }
       
        // Prepare game grid.
        self.createGameGrid(
            rows: game.getMap().getDimensions().getNumberOfRows(),
            columns: game.getMap().getDimensions().getNumberOfColumns(),
            inside: gameView
        )
        
        self.updateMovesLabel(with: player.numberOfMoves)
    }
    
    private func decorateViews() {
        guard let player = self.game.getPlayer() else {
            presentErrorAlert()
            return
        }
        
        self.playerTypeLabel.text = player.type == .runner ? "Runner" : "Seeker"
        
        self.finishButton.setup()
        self.finishButton.disable()
        self.undoButton.setup()
        self.undoButton.disable()
        
        self.versusProfileView.transformToCircle()
        self.versusEmojiIconView.transformToCircle()
        self.versusEmojiIconView.backgroundColor = player.type == .seeker ? UIColor(named: "RedAccentColor")?.withAlphaComponent(0.5) : UIColor(named: "FrostBlackColor")?.withAlphaComponent(0.5)
        
        self.profileView.transformToCircle()
        self.profileView.backgroundColor = .systemGreen.withAlphaComponent(0.5)
        self.emojiIconView.transformToCircle()
        self.emojiIconView.backgroundColor = player.type == .runner ? UIColor(named: "RedAccentColor")?.withAlphaComponent(0.5) : UIColor(named: "FrostBlackColor")?.withAlphaComponent(0.5)
        
        self.emojiIconLabel.text = ProfileIcon().getEmoji()
        self.againstEmojiIconLabel.text = ProfileIcon().getEmoji()
    }
    
    private func setupCancelButton() {
        self.cancelView.transformToCircle()
        self.cancelView.addButtonElevation()
        
        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(cancel))
        self.cancelView.addGestureRecognizer(cancelTap)
    }
}
