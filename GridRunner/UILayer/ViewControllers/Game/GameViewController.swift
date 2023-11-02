//
//  GameViewController.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 07.05.23.
//

import UIKit

class GameViewController: UIViewController {
        
    var isOnline: Bool = true
    
    let greetingView = GreetingView(
        frame: CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height)
    )
    
    // Programmable UI properties.
    let playerProfileView: ProfileView = ProfileView()
    let playerUsernameLabel: UsernameLabel = UsernameLabel()
    let playerTypeLabel: PlayerTypeLabel = PlayerTypeLabel()
    
    let opponentProfileView: ProfileView = ProfileView()
    let opponentUsernameLabel: UsernameLabel = UsernameLabel()
    let opponentTypeLabel: PlayerTypeLabel = PlayerTypeLabel()
    
    let turnCounter: CounterView = CounterView()
    let movesCounter: CounterView = CounterView()
    
    let gameView: UIView = UIView()
    
    let resignButton: GameButtonView = GameButtonView()
    let undoButton: GameButtonView = GameButtonView()
    let finishButton: GameButtonView = GameButtonView()
    
    let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        stackView.spacing = 20
        return stackView
    }()
    
    // Controller properties.
    var game = Game()
    var alertAdapter = AlertAdapter()
    var isPlayersTurn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "Background")
        
        self.setupGame()
    }
        
    private func setupGame() {
        if self.isOnline {
            self.initializeOnlineGame()
            NotificationCenter.default.addObserver(self, selector: #selector(updateGame), name: NSNotification.Name("Success:MoveResponse"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(finishGame), name: NSNotification.Name("Success:GameOver"), object: nil)
        } else {
            self.initializeOfflineGame()
        }
        
        guard let player = self.game.getPlayer() else { presentErrorAlert(); return }
                
        self.setupProfileViews(with: player)
        self.setupGameView()
        self.setupCounterViews()
        self.setupButtons()
        
        self.showGreetingView(with: player.type)
    }
    
    private func showGreetingView(with playerType: PlayerType) {
        UIView.animate(withDuration: 0.3, animations: {
            self.greetingView.playerType = playerType
            self.greetingView.setupLabels()
            self.view.addSubview(self.greetingView)
        })
    }
    
    @objc private func updateGame() {
        guard let player = game.getPlayer() else {
            presentErrorAlert()
            return
        }
        
        self.visualizeTurn(for: player, initial: false)
        
        if player.type == .runner && MoveResponse.shared.getPlayedBy() == .seeker {
            game.updateSeekerHistory()
            print(game.getHistory().outputSeekerHistory())
            for move in game.getHistory().getSeekerHistory()[player.currentTurnNumber - 2].getMoves() {
                self.accessTile(with: move.to, in: gameView)?.openBySeeker(explicit: true)
            }
        }
        
        if player.type == .seeker && MoveResponse.shared.getPlayedBy() == .server {
            game.updateRunnerHistory()
            print(game.getHistory().outputRunnerHistory())
            
            guard let serverTurn = MoveResponse.shared.getRunnerTurn() else { return }
            guard let firstMove = serverTurn.getMoves().first else { return }
            guard let secondMove = serverTurn.getMoves().last else { return }
            
            let secondMoveDirection = secondMove.identifyMoveDirection()
            
            // Need to reverse turn because to construct the move from server turn it uses reverse logic.
            // Construct move using current and future (not opened) move. Ordinary logic: old and current moves.
            serverTurn.reverse()
            
            self.accessTile(with: firstMove.to, in: gameView)?.openByRunner(
                explicit: true,
                lastTurn: serverTurn,
                oldTile: self.accessTile(with: secondMove.from, in: gameView),
                and: secondMoveDirection
            )
        }
        
        game.getHistory().outputHistory()
    }
    
    @objc private func finishGame() {
        guard let player = game.getPlayer() else {
            presentErrorAlert()
            return
        }
        
        // Construct all moves from total history on map.
        self.updateGameHistory(isOver: true)
        self.game.getHistory().outputHistory()
        self.reconstructRunnerHistory()
        self.reconstructSeekerHistory()
        
        if player.type == GameOver.shared.winner {
            guard let tile = self.accessTile(with: player.position, in: gameView) else { return }
            player.win(on: tile)
        }
        
        self.presentGameOverAlert()
    }
    
    @objc private func onResign() {
        if resignButton.isEnabled {
            let alert = alertAdapter.createResignAlert(alertActionHandler: { [weak self] in
                self?.transitionToMainScreen()
            })
            
            self.present(alert, animated: true)
        }
    }
    
    @objc func onUndo() {
        if undoButton.isEnabled {
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
    }
    
    @objc func onFinish() {
        if finishButton.isEnabled {
            guard let player = game.getPlayer() else {
                presentErrorAlert()
                return
            }
            
            player.finish()
            player.publishTurn()
            
            if let _ = player as? Runner {
                self.visualizeTurnForOpponent()
            }
            
            self.updateMovesCounter(with: player.numberOfMoves)
            self.updateTurnCounter(with: player.currentTurnNumber)
            
            self.undoButton.disable()
            self.finishButton.disable()
        }
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
        case .start where self.isPlayersTurn:
            self.startTileTapped(tile)
        case .closed where self.isPlayersTurn:
            self.closedTileTapped(tile)
        case .outer where self.isPlayersTurn:
            self.outerTileTapped(tile)
        case .exit where self.isPlayersTurn:
            self.basicTileTapped(tile, by: player)
        case .basic where self.isPlayersTurn:
            self.basicTileTapped(tile, by: player)
        default:
            return
        }
        
    }
    
    private func startTileTapped(_ tile: Tile) { }
    
    private func closedTileTapped(_ tile: Tile) { }
    
    private func outerTileTapped(_ tile: Tile) { }
    
    private func exitTileTapped(_ tile: Tile, by player: AnyPlayer) {}
    
    private func basicTileTapped(_ tile: Tile, by player: AnyPlayer) {
        let previousTile = self.accessTile(with: player.position, in: gameView)
        
        player.move(from: previousTile, to: tile)
        game.getHistory().setHistory(of: player.type, to: player.history)
        
        self.updateGameHUD(of: player)
    }
    
    private func accessTile(with coordinate: Coordinate, in view: UIView) -> Tile? {
        let min = -1
        let max = self.game.getMap().getDimensions().dimensions()
        
        print(max)
        
        let row = coordinate.y
        let column = coordinate.x
        
        if let view = view.subviews.first as? UIStackView {
            if row > min, row < max.rows, let row = view.arrangedSubviews[row] as? UIStackView {
                if column > min, column < max.columns, let tile = row.arrangedSubviews[column] as? Tile {
                    return tile
                }
            }
        }
        
        return nil
    }
    
    private func updateMovesCounter(with value: Int) {
        self.movesCounter.counter = "\(value)"
    }
    
    private func updateTurnCounter(with value: Int) {
        self.turnCounter.counter = "\(value)"
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
        self.highlightRunnerMoves()
        self.highlightSeekerMove()
        
        self.updateMovesCounter(with: player.numberOfMoves)
        self.updateTurnCounter(with: player.currentTurnNumber)
        
        // Handle enabling finish and undo buttons.
        self.enableUndoButton(on: player.numberOfMoves < player.maximumNumberOfMoves)
        self.enableFinishButton(on: player.numberOfMoves == 0)
    }
    
    private func presentGameOverAlert() {
        let alert = alertAdapter.createGameOverAlert(winner: GameOver.shared.winner, reason: GameOver.shared.reason, alertActionHandler: { [weak self] in
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
        if self.isOnline { AblyService.shared.leaveGame() }
        let mainViewController: MainViewController = MainViewController()
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.transitionViewController.transition(to: mainViewController, with: [.transitionCurlDown])
    }
    
    func highlightRunnerMoves() {
        guard let runner = self.game.getPlayer() as? Runner else { return }
        
        // Remove not needed highlights.
        let noLongerPossibleMoveCoordinates = runner.getNoLongerPossibleMoveCoordinates()
        
        for coordinate in noLongerPossibleMoveCoordinates {
            let tile = self.accessTile(with: coordinate, in: self.gameView)
            tile?.removeHighlight()
        }
        
        // Add new highlights.
        let possibleMoveCoordinates = runner.getPossibleMoveCoordinates()
        
        for coordinate in possibleMoveCoordinates {
            let tile = self.accessTile(with: coordinate, in: self.gameView)
            tile?.decorateRunnerHighlight()
        }
    }
    
    func highlightSeekerMove() {
        guard let seeker = self.game.getPlayer() as? Seeker else { return }
        
        // Access previous to last element from Seeker history.
        if let previousToLastToCoordinate = seeker.history.dropLast(1).last?.getMoves().last?.to {
            let tile = self.accessTile(with: previousToLastToCoordinate, in: self.gameView)
            tile?.decorateSeekerHighlight()
        }
        
        // Access last element from Seeker history.
        if let lastFromCoordinate = seeker.history.last?.getMoves().last?.from {
            let tile = self.accessTile(with: lastFromCoordinate, in: self.gameView)
            tile?.removeHighlight()
        }
        
        // Access last element from Seeker history.
        if let lastToCoordinate = seeker.history.last?.getMoves().last?.to {
            let tile = self.accessTile(with: lastToCoordinate, in: self.gameView)
            tile?.decorateSeekerHighlight()
        }
    }
    
    private func initializeOfflineGame() {
        let map = Map(with: MapDimensions(13, by: 13))
        let player = Runner(at: map.getCenterCoordinates())
        self.game.createSession(with: map, for: player)
        
        // Prepare game grid.
        self.createGameGrid(
            rows: game.getMap().getDimensions().getNumberOfRows(),
            columns: game.getMap().getDimensions().getNumberOfColumns(),
            inside: gameView
        )
        
        self.updateMovesCounter(with: player.numberOfMoves)
        self.updateTurnCounter(with: player.currentTurnNumber)
        
        // Checks if player is Runner. If Runner highlights possible move coordinates.
        self.highlightRunnerMoves()
    }
    
    private func initializeOnlineGame() {
        let map = Map(with: MapDimensions(GameConfig.shared.grid.height, by: GameConfig.shared.grid.width))
        
        guard let startTile = GameConfig.shared.grid.tiles.first(where: {$0.type == .start}) else {
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
            
            switch (GameConfig.shared.runner, GameConfig.shared.seeker) {
            case (clientId, _):
                return Runner(at: startTile.position)
            case ("you", _):
                return Runner(at: startTile.position)
            case (_, clientId):
                return Seeker(at: startTile.position)
            case (_, "you"):
                return Seeker(at: startTile.position)
            default:
                self.presentErrorAlert()
                return Runner(at: startTile.position)
            }
        }
        
        let history = History(with: GameConfig.shared.history.runner, and: GameConfig.shared.history.seeker)
        
        self.game.createSession(
            with: map,
            for: player,
            with: history
        )
        
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
        
        self.updateGameHistory(isOver: false)
        self.reconstructRunnerHistory()
        self.reconstructSeekerHistory()
        self.updateMovesCounter(with: player.numberOfMoves)
        self.updateTurnCounter(with: player.currentTurnNumber)
        
        // Checks if player is Runner. If Runner highlights possible move coordinates.
        self.highlightRunnerMoves()
    }
    
    private func setupGameView() {
        self.gameView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.gameView)

        NSLayoutConstraint.activate([
            self.gameView.topAnchor.constraint(equalTo: self.playerTypeLabel.bottomAnchor, constant: Dimensions.verticalSpacing20),
            self.gameView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            self.gameView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5)
        ])
    }
    
    private func setupProfileViews(with player: AnyPlayer) {
        self.playerProfileView.textSize = Dimensions.buttonFont
        self.playerProfileView.setup(in: self.view)
        self.playerProfileView.color = player.type == .runner ? UIColor(named: "Red") : UIColor(named: "Gray")
        self.playerTypeLabel.setup(in: self.view, as: player.type == .runner ? "Runner" : "Seeker")
        
        self.opponentProfileView.textSize = Dimensions.buttonFont
        self.opponentProfileView.setup(in: self.view)
        self.opponentProfileView.text = ProfileIcon.shared.enemyIcon
        self.opponentProfileView.color = player.type == .runner ? UIColor(named: "Gray") : UIColor(named: "Red")
        self.opponentUsernameLabel.textAlignment = .right
        self.opponentTypeLabel.setup(in: self.view, as: player.type == .runner ? "Seeker" : "Runner")
        self.opponentTypeLabel.textAlignment = .right
        
        self.setupProfileViewLabels(with: player)
        
        NSLayoutConstraint.activate([
            self.playerProfileView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.playerProfileView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.playerUsernameLabel.topAnchor.constraint(equalTo: self.playerProfileView.bottomAnchor, constant: 5),
            self.playerUsernameLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.playerUsernameLabel.trailingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -10),
            self.playerTypeLabel.topAnchor.constraint(equalTo: self.playerUsernameLabel.bottomAnchor),
            self.playerTypeLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.playerTypeLabel.trailingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -10),
            self.opponentProfileView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.opponentProfileView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            self.opponentUsernameLabel.topAnchor.constraint(equalTo: self.opponentProfileView.bottomAnchor, constant: 5),
            self.opponentUsernameLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            self.opponentUsernameLabel.leadingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 10),
            self.opponentTypeLabel.topAnchor.constraint(equalTo: self.playerUsernameLabel.bottomAnchor),
            self.opponentTypeLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            self.opponentTypeLabel.leadingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 10),
        ])
        
        self.visualizeTurn(for: player, initial: true)
    }
    
    private func setupProfileViewLabels(with player: AnyPlayer) {
        if self.isOnline {
            self.playerUsernameLabel.setup(in: self.view, as: player.type == .runner ? "@\(GameConfig.shared.runner ?? "you")" : "@\(GameConfig.shared.seeker ?? "you")")
            self.opponentUsernameLabel.setup(in: self.view, as: "@\(GameConfig.shared.opponent)")
        } else {
            self.playerUsernameLabel.setup(in: self.view, as: "@you")
            self.opponentUsernameLabel.setup(in: self.view, as: "@opponent")
        }
    }
    
    private func setupCounterViews() {
        self.movesCounter.label = "move(s) left"
        self.turnCounter.label = "turn"
        
        self.view.addSubview(movesCounter)
        self.view.addSubview(turnCounter)
        
        NSLayoutConstraint.activate([
            self.movesCounter.topAnchor.constraint(equalTo: self.gameView.bottomAnchor, constant: Dimensions.verticalSpacing20 * 2),
            self.movesCounter.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.turnCounter.topAnchor.constraint(equalTo: self.movesCounter.bottomAnchor, constant: Dimensions.verticalSpacing20 / 2),
            self.turnCounter.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
        ])
    }
    
    private func setupButtons() {
        self.view.addSubview(self.buttonsStackView)
        
        NSLayoutConstraint.activate([
            self.buttonsStackView.topAnchor.constraint(equalTo: self.turnCounter.bottomAnchor, constant: Dimensions.verticalSpacing20 * 2),
            self.buttonsStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            self.buttonsStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            self.buttonsStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -Dimensions.verticalSpacing20),
        ])
                
        self.resignButton.text = "Resign"
        self.undoButton.text = "Undo"
        self.finishButton.text = "Finish"
        
        self.resignButton.image = UIImage(systemName: "arrow.uturn.left")
        self.undoButton.image = UIImage(systemName: "arrow.counterclockwise")
        self.finishButton.image = UIImage(systemName: "checkmark")
        
        self.buttonsStackView.addArrangedSubview(resignButton)
        self.buttonsStackView.addArrangedSubview(undoButton)
        self.buttonsStackView.addArrangedSubview(finishButton)
        
        let resignGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onResign))
        let undoGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onUndo))
        let finishGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onFinish))
        
        self.resignButton.addGestureRecognizer(resignGestureRecognizer)
        self.undoButton.addGestureRecognizer(undoGestureRecognizer)
        self.finishButton.addGestureRecognizer(finishGestureRecognizer)
        
        self.resignButton.enable()
        self.undoButton.disable()
        self.finishButton.disable()
    }
    
    private func visualizeTurn(for player: AnyPlayer, initial: Bool) {
        let compareAgainstType: PlayerType = initial ? GameConfig.shared.getCurrentTurn() : MoveResponse.shared.getNextTurn()
        
        if player.type == compareAgainstType {
            self.isPlayersTurn = true
            self.playerProfileView.setBorderColor(to: .systemGreen)
            self.opponentProfileView.setBorderColor(to: UIColor(named: "Background"))
            
            // Highlight when turn comes back to Runner.
            self.highlightRunnerMoves()
        } else {
            self.isPlayersTurn = false
            self.playerProfileView.setBorderColor(to: UIColor(named: "Background"))
            self.opponentProfileView.setBorderColor(to: .systemGreen)
        }
    }
    
    private func visualizeTurnForOpponent() {
        self.isPlayersTurn = false
        self.playerProfileView.setBorderColor(to: UIColor(named: "Background"))
        self.opponentProfileView.setBorderColor(to: .systemGreen)
    }
    
    private func updateGameHistory(isOver over: Bool) {
        let runnerHistory = over ? GameOver.shared.history.runner : GameConfig.shared.history.runner
        let seekerHistory = over ? GameOver.shared.history.seeker : GameConfig.shared.history.seeker
        
        game.getHistory().setRunnerHistory(to: runnerHistory)
        game.getHistory().setSeekerHistory(to: seekerHistory)
    }
    
    private func reconstructSeekerHistory() {
        for turn in game.getHistory().seeker {
            for move in turn.getMoves() {
                self.accessTile(with: move.to, in: gameView)?.openBySeeker(explicit: true)
            }
        }
    }
    
    private func reconstructRunnerHistory() {
        for turn in game.getHistory().getRunnerHistory() {
            for move in turn.getMoves() {
                self.accessTile(with: move.to, in: gameView)?.openByRunner(
                    explicit: true,
                    lastTurn: game.getHistory().getRunnerHistory().prefix(while: {$0.id != turn.id}).last,
                    oldTile: self.accessTile(with: move.from, in: gameView),
                    and: move.identifyMoveDirection())
            }
        }
    }
}
