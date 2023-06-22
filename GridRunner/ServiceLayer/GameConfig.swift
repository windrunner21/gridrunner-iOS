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
    var runner: String?
    var seeker: String?
    var opponent: String
    var runnerMovesLeft: Int
    var seekerMovesLeft: Int
    private var turn: String
    private var turnHistory: TurnHistory
    var type: String
    
    var description: String {
        "GameConfig is initialized. Current turn is \(turn)'s. Runner is: \(runner ?? "X"). Seeker is: \(seeker ?? "X"). Opponent is: \(opponent). Number of moves left for Runner: \(runnerMovesLeft). Number of moves left for Seeker: \(seekerMovesLeft). Type: \(type). \(grid). \(turnHistory)."
    }
    
    private override init() {
        self.grid = Grid()
        self.runner = String()
        self.seeker = String()
        self.opponent = String()
        self.runnerMovesLeft = Int()
        self.seekerMovesLeft = Int()
        self.turn = String()
        self.turnHistory = TurnHistory()
        self.type = String()
    }
    
    private init(grid: Grid, runner: String, seeker: String, opponent: String, runnerMovesLeft: Int, seekerMovesLeft: Int, turn: String, turnHistory: TurnHistory, type: String) {
        self.grid = grid
        self.runner = runner
        self.seeker = seeker
        self.opponent = opponent
        self.runnerMovesLeft = runnerMovesLeft
        self.seekerMovesLeft = seekerMovesLeft
        self.turn = turn
        self.turnHistory = turnHistory
        self.type = type
    }
    
    func update(with config: GameConfig) {
        self.grid = config.grid
        self.runner = config.runner
        self.seeker = config.seeker
        self.opponent = config.opponent
        self.runnerMovesLeft = config.runnerMovesLeft
        self.seekerMovesLeft = config.seekerMovesLeft
        self.turn = config.turn
        self.turnHistory = config.turnHistory
        self.type = config.type
    }
    
    func getTurnPlayerType() -> PlayerType {
        if self.turn == "runner" {
            return .runner
        }else {
            return .seeker
        }
    }
     
    func getHistory() -> History {
        return turnHistory.toHistory()
    }
}
