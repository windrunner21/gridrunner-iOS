//
//  GameViewController.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 07.05.23.
//

import UIKit

class GameViewController: UIViewController {
    
    let loadingView = LoadingView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    // Storyboard properties.
    @IBOutlet weak var playerTypeLabel: UILabel!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var emojiIconLabel: UILabel!
    @IBOutlet weak var versusEmojiIconLabel: UILabel!
    
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var versusPlayerLabel: UILabel!
    
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
        self.view.addSubview(self.loadingView)
        
        AblyService.shared.enterGame()

        NotificationCenter.default.addObserver(self, selector: #selector(setupGame), name: NSNotification.Name("Success:GameConfig"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateGame), name: NSNotification.Name("Success:MoveResponse"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishGame), name: NSNotification.Name("Success:GameOver"), object: nil)
    }
    
    @objc private func setupGame() {
        self.setupCancelButton()
        self.setupUndoButton()
        self.setupFinishButton()
        
        self.loadingView.remove()
        
        self.initializeGame()
        
        self.setupProfileView()
        self.setupVersusProfileView()
    }
    
    @objc private func updateGame() {
        guard let player = game.getPlayer() else {
            presentErrorAlert()
            return
        }
        
        self.visualizeTurn(for: player, initial: false)
        
        if player.type == .runner && MoveResponse.shared.getPlayedBy() == .seeker {
            game.updateSeekerHistory()
            print(player.currentTurnNumber)
            print(game.getHistory().getSeekerHistory())
            for move in game.getHistory().getSeekerHistory()[player.currentTurnNumber - 2].getMoves() {
                self.accessTile(with: move.to, in: gameView)?.openBySeeker(explicit: true)
            }
        }
        
        if player.type == .seeker && MoveResponse.shared.getPlayedBy() == .server {
            game.updateRunnerHistory()
            print(player.currentTurnNumber)
            print(game.getHistory().getRunnerHistory())
            for move in game.getHistory().getRunnerHistory()[player.currentTurnNumber - 2].getMoves() {
                let direction = move.identifyMoveDirection()
                self.accessTile(with: move.to, in: gameView)?.openByRunner(explicit: true)
                // TODO: update as on board => change tile at 1st to or 2nd from and use 1st and 2nd directions
                // TODO: either write new method or reuse one in tile.
           }
        }
        
        game.getHistory().outputHistory()
    }
    
    @objc private func finishGame() {
        guard let player = game.getPlayer() else {
            presentErrorAlert()
            return
        }
        
        if player.type == GameOver.shared.getWinner() {
            guard let tile = self.accessTile(with: player.position, in: gameView) else { return }
            player.win(on: tile)
        }
        
        self.presentGameOverAlert()
    }
    
    @objc private func cancel() {
        AblyService.shared.leaveGame()
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
        
        player.finish()
        player.publishTurn()
        
        if let _ = player as? Runner {
            self.visualizeTurnForOpponent()
        }
        
        self.updateMovesLabel(with: player.numberOfMoves)
        
        self.undoButton.disable()
        self.finishButton.disable()
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

                tile.position = Coordinate(x: column, y: row)
                tile.setIdentifier("\(column)\(row)")
                tile.setupTile(at: row, and: column, with: game.getMap().getDimensions(), and: game.getHistory())

                let tileTap = UITapGestureRecognizer(target: self, action: #selector(tileTapped))
                tile.addGestureRecognizer(tileTap)
                
                horizontalStackView.addArrangedSubview(tile)
            }
            
            verticalStackView.addArrangedSubview(horizontalStackView)
        }
        
        // NOTE: GameConfig can be initialized multiple times. Remove and renew view insteaf of pilling them up.
        if rootView.subviews.isEmpty {
            rootView.addSubview(verticalStackView)
        } else {
            for subview in rootView.subviews {
                subview.removeFromSuperview()
            }
            
            rootView.addSubview(verticalStackView)
        }
        
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
            self.basicTileTapped(tile, by: player)
        default:
            self.basicTileTapped(tile, by: player)
        }
        
    }
    
    private func startTileTapped(_ tile: Tile) { }
    
    private func exitTileTapped(_ tile: Tile, by player: AnyPlayer) {}
    
    private func basicTileTapped(_ tile: Tile, by player: AnyPlayer) {
        let previousTile = self.accessTile(with: player.position, in: gameView)
        
        player.move(from: previousTile, to: tile)
        game.getHistory().setHistory(of: player.type, to: player.history)
        
        self.updateGameHUD(of: player)
    }
    
    private func accessTile(with coordinate: Coordinate, in view: UIView) -> Tile? {
        let row = coordinate.y
        let column = coordinate.x
        
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
    
    private func presentGameOverAlert() {
        let alert = alertAdapter.createGameOverAlert(winner: GameOver.shared.getWinner(), reason: GameOver.shared.reason, alertActionHandler: { [weak self] in
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
        print(GameConfig.shared)
        
        let map = Map(with: MapDimensions(GameConfig.shared.grid.height, by: GameConfig.shared.grid.width))
        
        guard let startTile = GameConfig.shared.grid.tiles().first(where: {$0.type == .start}) else {
            print("Cound not get start tile")
            self.presentErrorAlert()
            return
        }
        
        var player: AnyPlayer {
            guard let clientId = AblyService.shared.getClientId() else {
                print("Cound not get Client Id")
                self.presentErrorAlert()
                return Runner(at: startTile.position)
            }
            
            return clientId == GameConfig.shared.runner ?
            Runner(at: startTile.position) : Seeker(at: startTile.position)
        }
        
        let history = GameConfig.shared.getHistory()
        
        self.game.createSession(
            with: map,
            for: player,
            with: history
        )
        
        NSLog("Game has been instantiated.")
        
        // If player could not have been instatiated return.
        guard let player = game.getPlayer() else {
            print("Cound not get Player")
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
        self.visualizeTurn(for: player, initial: true)
    }
    
    private func setupCancelButton() {
        self.cancelView.transformToCircle()
        self.cancelView.addButtonElevation()
        
        let cancelTap = UITapGestureRecognizer(target: self, action: #selector(cancel))
        self.cancelView.addGestureRecognizer(cancelTap)
    }
    
    private func setupProfileView() {
        guard let player = self.game.getPlayer() else {
            presentErrorAlert()
            return
        }
        
        self.playerTypeLabel.text = player.type == .runner ? "Runner" : "Seeker"
        
        self.profileView.transformToCircle()
        self.profileView.addLightBorder()
        self.emojiIconView.transformToCircle()
        self.emojiIconView.backgroundColor = player.type == .runner ? UIColor(named: "RedAccentColor")?.withAlphaComponent(0.5) : UIColor(named: "FrostBlackColor")?.withAlphaComponent(0.5)
        
        self.emojiIconLabel.text = ProfileIcon().getEmoji()
        
        self.playerLabel.text = player.type == .runner ?
        "@\(GameConfig.shared.runner ?? "username")" :
        "@\(GameConfig.shared.seeker ?? "username")"
    }
    
    private func setupVersusProfileView() {
        guard let player = self.game.getPlayer() else {
            presentErrorAlert()
            return
        }
        
        self.versusProfileView.transformToCircle()
        self.versusProfileView.addLightBorder()
        self.versusEmojiIconView.transformToCircle()
        self.versusEmojiIconView.backgroundColor = player.type == .seeker ? UIColor(named: "RedAccentColor")?.withAlphaComponent(0.5) : UIColor(named: "FrostBlackColor")?.withAlphaComponent(0.5)
        
        self.versusEmojiIconLabel.text = ProfileIcon().getEmoji()
        self.versusPlayerLabel.text = "@\(GameConfig.shared.opponent)"
    }
    
    private func setupUndoButton() {
        self.undoButton.setup()
        self.undoButton.disable()
    }
    
    private func setupFinishButton() {
        self.finishButton.setup()
        self.finishButton.disable()
    }
    
    private func visualizeTurn(for player: AnyPlayer, initial: Bool) {
        let compareAgainstType: PlayerType = initial ? GameConfig.shared.getCurrentTurn() : MoveResponse.shared.getNextTurn()
        
        if player.type == compareAgainstType {
            self.profileView.backgroundColor = .systemGreen.withAlphaComponent(0.5)
            self.versusProfileView.backgroundColor = .white
        } else {
            self.profileView.backgroundColor = .white
            self.versusProfileView.backgroundColor = .systemGreen.withAlphaComponent(0.5)
        }
    }
    
    private func visualizeTurnForOpponent() {
        self.profileView.backgroundColor = .white
        self.versusProfileView.backgroundColor = .systemGreen.withAlphaComponent(0.5)
    }
}
