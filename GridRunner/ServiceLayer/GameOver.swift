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
    private var winner: String?
    var type: String
    var reason: String?
    
    var description: String {
        "Game is over. Winner is: \(winner ?? "none"). History is: \(turnHistory)"
    }
    
    private override init() {
        self.turnHistory = TurnHistory()
        self.winner = String()
        self.type = String()
        self.reason = nil
    }
    
    func update(with gameOver: GameOver) {
        self.turnHistory = gameOver.turnHistory
        self.winner = gameOver.winner
        self.type = gameOver.type
        self.reason = gameOver.reason
    }
    
    func getHistory() -> History {
        turnHistory.toHistory()
    }
    
    func getWinner() -> PlayerType {
        switch self.winner {
        case "runner":
            return .runner
        case "seeker":
            return .seeker
        default:
            return .server
        }
    }
}
