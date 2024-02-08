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
            return gameAlgorithms.runnerAlgorithm()
        case .seeker:
            return gameAlgorithms.seekerAlgorithm()
        default:
            return nil
        }
    }
}
