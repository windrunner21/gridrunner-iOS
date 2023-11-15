//
//  Bot.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 18.09.23.
//

import Foundation

struct Bot {
    var gameAlgorithms: GameAlgo
    var difficulty: GameDifficulty
    
    init(difficulty: GameDifficulty) {
        self.gameAlgorithms = GameAlgo()
        self.gameAlgorithms.generateGameTree()
        self.difficulty = difficulty
    }
    
    func calculateBestMove(for player: PlayerType) -> Move? {
        // use grid run game algo
        switch player {
        case .runner:
            gameAlgorithms.runnerAlgorithm()
            return Move(from: Coordinate(x: 0, y: 0), to: Coordinate(x: 4, y: 4))
        case .seeker:
            gameAlgorithms.seekerAlgorithm()
            return Move(from: Coordinate(x: 0, y: 0), to: Coordinate(x: 3, y: 3))
        default:
            return nil
        }    }
}
