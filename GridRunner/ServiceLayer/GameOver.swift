//
//  GameOver.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 02.07.23.
//

import Foundation

class GameOver: ResponseParser, Decodable, CustomStringConvertible {
    static let shared = GameOver()
    
    private var turnHistory: TurnHistory
    var winner: String
    var type: String
    
    var description: String {
        "Game is over. Winner is: \(winner). History is: \(turnHistory)"
    }
    
    private override init() {
        self.turnHistory = TurnHistory()
        self.winner = String()
        self.type = String()
    }
    
    private init(turnHistory: TurnHistory, winner: String, type: String) {
        self.turnHistory = turnHistory
        self.winner = winner
        self.type = type
    }
    
    func update(with gameOver: GameOver) {
        self.turnHistory = gameOver.turnHistory
        self.winner = gameOver.winner
        self.type = gameOver.type
    }
    
    func getHistory() -> History {
        return turnHistory.toHistory()
    }
}
