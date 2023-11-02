//
//  GameOver.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 02.11.23.
//

class GameOver: GameOverProtocol {
    static let shared = GameOver()
    
    var winner: PlayerType
    var type: String
    var reason: String?
    var history: HistoryProtocol
    
    private init() {
        self.winner = .server
        self.type = String()
        self.reason = nil
        self.history = History()
    }
    
    func update(with gameOver: GameOverProtocol) {
        self.winner = gameOver.winner
        self.type = gameOver.type
        self.reason = gameOver.reason
        self.history = gameOver.history
    }
}
