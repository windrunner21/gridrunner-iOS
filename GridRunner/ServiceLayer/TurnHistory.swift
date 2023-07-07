//
//  TurnHistory.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 19.06.23.
//

import Foundation

class TurnHistory: ResponseParser, Decodable, CustomStringConvertible {
    var runnerHistory: [[SLMove]]
    var seekerHistory: [[SLMove]]
    
    var description: String {
        "Turn history = runner history as: \(runnerHistory) and seeker history as: \(seekerHistory)"
    }
    
    override init() {
        self.runnerHistory = []
        self.seekerHistory = []
    }
    
    func toHistory() -> History {
        History(with: self.convertToRunnerHistory(), and: self.convertToSeekerHistory())
    }
    
    private func convertToRunnerHistory() -> [Turn] {
        var moves: [Move] = []
        var turns: [Turn] = []
        
        for turn in self.runnerHistory {
            moves = []
            
            for move in turn {
                guard let runnerMove = move.getRunnerMove() else { break }
                moves.append(runnerMove)
            }
            
            turns.append(Turn(moves: moves))
        }
        
        return turns
    }
    
    private func convertToSeekerHistory() -> [Turn] {
        var moves: [Move] = []
        var turns: [Turn] = []
        guard let centerCoordinates = GameConfig.shared.grid.tiles().first(where: {$0.type == .start})?.position else { return [] }
        
        for turn in self.seekerHistory {
            moves = []
            
            for move in turn {
                guard let seekerCoordinate = move.getCoordinate() else { return [] }
                let move = Move(from: turns.last?.getMoves().last?.to ?? centerCoordinates, to: seekerCoordinate)
                moves.append(move)
            }
            
            turns.append(Turn(moves: moves))
        }
        
        return turns
    }
}
