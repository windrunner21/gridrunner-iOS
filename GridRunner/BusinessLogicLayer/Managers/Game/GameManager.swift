//
//  GameManager.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 04.11.23.
//

struct GameManager {
    let game: Game
    let isOnlineGame: Bool
    var isPlayerTurn: Bool
    let alertAdapter: AlertAdapter
    
    // Config related properties
    let onlineGrid = GameConfig.shared.grid
    let onlineHistory = GameConfig.shared.history
    
    init(offline: Bool? = nil) {
        self.game = Game()
        self.isOnlineGame = offline ?? true
        self.isPlayerTurn = false
        self.alertAdapter = AlertAdapter()
    }
    
    func initializeGame() throws {
        if isOnlineGame {
            try self._initializeOnlineGame()
        } else {
            self._initializeOfflineGame()
        }
    }
    
    func finishGame() {
        // Construct all moves from total history on map.
        self.updateGameHistory(isGameOver: true)
        // Output overall history for testing purposes
        self.game.getHistory().outputHistory()
        if self.isOnlineGame { AblyService.shared.leaveGame() }
    }
    
    func abortGame() {
        // Output overall history for testing purposes
        self.game.getHistory().outputHistory()
        if self.isOnlineGame { AblyService.shared.leaveGame() }
    }
    
    func ondoMove() throws -> (AnyPlayer, Move)  {
        guard let player = self.game.getPlayer() else { throw GameError.noPlayer }
        guard let lastMove = player.history.last?.getMoves().last else { throw GameError.noLastMove}
        player.undo(lastMove)
        return(player, lastMove)
    }
    
    func finishMove() throws {
        guard let player = self.game.getPlayer() else { throw GameError.noPlayer }
        player.finish()
        player.publishTurn()
    }
    
    func updateGameToMoveResponse(runnerLogic: (Move)->Void, seekerLogic: (Move, Move, Turn, MoveDirection)->Void) throws {
        guard let player = self.game.getPlayer() else { throw GameError.noPlayer }
                
        if player.type == .runner && MoveResponse.shared.getPlayedBy() == .seeker {
            self.game.updateSeekerHistory()
            for move in self.game.getHistory().seeker[player.currentTurnNumber - 2].getMoves() {
                runnerLogic(move)
            }
        }
        
        if player.type == .seeker && MoveResponse.shared.getPlayedBy() == .server {
            self.game.updateRunnerHistory()
            
            guard let serverTurn = MoveResponse.shared.getRunnerTurn() else { return }
            guard let firstMove = serverTurn.getMoves().first else { return }
            guard let secondMove = serverTurn.getMoves().last else { return }
            
            let secondMoveDirection = secondMove.identifyMoveDirection()
            
            // Need to reverse turn because to construct the move from server turn it uses reverse logic.
            // Construct move using current and future (not opened) move. Ordinary logic: old and current moves.
            serverTurn.reverse()
            
            seekerLogic(firstMove, secondMove, serverTurn, secondMoveDirection)
        }
        
        self.game.getHistory().outputHistory()
    }
    
    func updateGameHistory(isGameOver over: Bool) {
        let onlineOverHistory = GameOver.shared.history
        
        let runnerHistory = over ? onlineOverHistory.runner : onlineHistory.runner
        let seekerHistory = over ? onlineOverHistory.seeker : onlineHistory.seeker
        self.game.getHistory().setRunnerHistory(to: runnerHistory)
        self.game.getHistory().setSeekerHistory(to: seekerHistory)
    }
    
    mutating func switchToPlayer() {
        self.isPlayerTurn = true
    }
    
    mutating func switchToOpponent() {
        self.isPlayerTurn = false
    }
    
    private func _initializeOnlineGame() throws {
        guard let clientId = AblyService.shared.getClientId() else { throw GameError.missingClientId }
        guard let startTile = onlineGrid.tiles.first(where: { $0.type == .start }) else { throw GameError.missingStartTile }
        
        let mapDimensions = MapDimensions(onlineGrid.height, by: onlineGrid.width)
        
        let map = Map(with: mapDimensions)
        let player = self._initializePlayer(from: clientId, at: startTile)
        let history = History(with: onlineHistory.runner, and: onlineHistory.seeker)
        
        guard let player = player else { throw GameError.noPlayer }
        
        self.game.createSession(
            with: map,
            for: player,
            with: history
        )
        
        self.updateGameHistory(isGameOver: false)
    }
    
    private func _initializeOfflineGame() {
        
    }
    
    private func _initializePlayer(from id: String, at tile: Tile) -> AnyPlayer? {
        if GameConfig.shared.runner == id || GameConfig.shared.runner == "you" {
            return Runner(at: tile.position)
        } else if GameConfig.shared.seeker == id || GameConfig.shared.seeker == "you" {
            return Seeker(at: tile.position)
        } else {
            return nil
        }
    }
}
