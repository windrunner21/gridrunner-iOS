//
//  OnlineGameConfig.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 27.10.23.
//

class GameConfig: Configurable {
    static let shared = GameConfig()
    
    // change name to game config and online config in model
    var grid: GridProtocol
    var runner: String?
    var seeker: String?
    var opponent: String
    var runnerMovesLeft: Int
    var seekerMovesLeft: Int
    var turn: String
    var turnHistory: TurnHistory
    var type: String
    
    private init() {
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
    
    func getHistory() -> History {
        return turnHistory.toHistory()
    }
    
    func getCurrentTurn() -> PlayerType {
        self.turn == "seeker" ? .seeker : .runner
    }    
}
