//
//  OfflineGameConfig.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 02.11.23.
//

import Foundation

struct OfflineGameConfig: Configurable {
    var grid: GridProtocol
    var runner: String?
    var seeker: String?
    var opponent: String
    var runnerMovesLeft: Int
    var seekerMovesLeft: Int
    var turn: String
    var history: HistoryProtocol
    var type: String
    var difficulty: Difficulty
    
    init(role: PlayerRole, map: MapType, difficulty: Difficulty) {
        self.grid = Grid()
        self.opponent = ""
        self.runnerMovesLeft = 2
        self.seekerMovesLeft = 1
        self.turn = "runner"
        self.history = History()
        self.type = "config"
        
        self.difficulty = difficulty
        self._initializePlayers(by: role)
        self._initializeMap(by: map)
    }
    
    private mutating func _initializeMap(by type: MapType) {
        do {
            var grid = Grid()
            try grid.setupGrid(as: type)
            self.grid = grid
        } catch {
            Log.error("Unknown Map Type confronted")
        }
    }
    
    private mutating func _initializePlayers(by role: PlayerRole) {
        switch role {
        case .runner:
            self.runner = "you"
            self.opponent = "seeker"
        case .seeker:
            self.seeker = "you"
            self.opponent = "runner"
        case .random:
            RandomGenerator.random(a: {
                    self.runner = "you"
                    self.opponent = "seeker"
            }, b: {
                self.seeker = "you"
                self.opponent = "runner"
            })
        default:
            return
        }
    }
}
