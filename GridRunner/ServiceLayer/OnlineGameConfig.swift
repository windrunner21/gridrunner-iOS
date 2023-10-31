//
//  GameConfig.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 19.06.23.
//

import Foundation

class OnlineGameConfig: ResponseParser, Decodable, CustomStringConvertible, Configurable {
    var grid: Grid
    var runner: String?
    var seeker: String?
    var opponent: String
    var runnerMovesLeft: Int
    var seekerMovesLeft: Int
    var turn: String
    var turnHistory: TurnHistory
    var type: String
    
    var description: String {
        "GameConfig description. Current turn is \(turn)'s. Runner is: \(runner ?? "X"). Seeker is: \(seeker ?? "X"). Opponent is: \(opponent). Number of moves left for Runner: \(runnerMovesLeft). Number of moves left for Seeker: \(seekerMovesLeft). Type: \(type). \(grid). \(turnHistory)."
    }
    
    func update(with config: Configurable) {
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
}
