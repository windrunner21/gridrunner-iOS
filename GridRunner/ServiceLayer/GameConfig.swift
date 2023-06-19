//
//  GameConfig.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 19.06.23.
//

import Foundation

class GameConfig: ResponseParser, Decodable, CustomStringConvertible {
    static let shared = GameConfig()
    
    var grid: Grid
    var movesLeft: Int
    var runner: String
    var turn: String
    var turnHistory: TurnHistory
    var type: String
    
    var description: String {
        "GameConfig is initialized. Current turn is \(turn)'s. Runner is: \(runner). Number of moves left: \(movesLeft). Type: \(type). \(grid). \(turnHistory)"
    }
    
    private override init() {
        self.grid = Grid()
        self.movesLeft = Int()
        self.runner = String()
        self.turn = String()
        self.turnHistory = TurnHistory()
        self.type = String()
    }
    
    private init(grid: Grid, movesLeft: Int, runner: String, turn: String, turnHistory: TurnHistory, type: String) {
        self.grid = grid
        self.movesLeft = movesLeft
        self.runner = runner
        self.turn = turn
        self.turnHistory = turnHistory
        self.type = type
    }
    
    func update(with details: GameConfig) {
        self.grid = details.grid
        self.movesLeft = details.movesLeft
        self.runner = details.runner
        self.turn = details.turn
        self.turnHistory = details.turnHistory
        self.type = details.type
    }
}
