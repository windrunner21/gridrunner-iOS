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
