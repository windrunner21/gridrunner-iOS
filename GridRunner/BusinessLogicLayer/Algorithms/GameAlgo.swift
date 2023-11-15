//
//  GameAlgo.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 15.11.23.
//

import Foundation

struct GameAlgo {
    /*
     use minimax?
     chess or tic tac toe cannot finish the game right away
     grid run can be finished from seeker's perspective right away => corner the runner and find it, radius depending on dif.
     grid run cannot be finished from runner's perspective right away
     can write minimax for user as seeker and ai as runner
     for other way around need to change the logic?
    */
    
    func generateGameTree() {
        // first build tree using root game node
    }
    
    func runnerAlgorithm() {
        /*
         runner starts the game
         runner finishes the game?
        */
        // make random move if first
        // make move towards nearest exit and if seeker is not in vicinity
        // construct game tree
    }
    
    func seekerAlgorithm() {
        /*
         runner starts the game
         seeker finishes the game?
        */
    }
    
    private func minimax(game: Game, depth: Int, isMaximizing: Bool, currentPlayer: PlayerType) -> Int {
        if depth == 0 { return 0 }
        
        if isMaximizing {
            var maxEvaluation = Int.min
            
            // check if need to do that
            let opponent: PlayerType = currentPlayer == .runner ? .seeker : .runner
            
            for i in 0..<game.getMap().getDimensions().getNumberOfRows() {
                for j in 0..<game.getMap().getDimensions().getNumberOfColumns() {
                    // MARK: check if need to access runner history/check if should go each turn from last till find?
                    // MARK: create aux function for above
                    if let lastTurn = game.getHistory().runner.last, !lastTurn.getMoves().contains(where: { $0.to == Coordinate(x: i, y: j)}) {
                        let maxValue = minimax(game: game, depth: depth - 1, isMaximizing: false, currentPlayer: opponent)
                        maxEvaluation = max(maxEvaluation, maxValue)
                    }
                }
            }
            
            return maxEvaluation
        } else {
            var minEvaluation = Int.max
            
            // check if need to do that
            let opponent: PlayerType = currentPlayer == .runner ? .seeker : .runner
            
            for i in 0..<game.getMap().getDimensions().getNumberOfRows() {
                for j in 0..<game.getMap().getDimensions().getNumberOfColumns() {
                    // MARK: check if need to access runner history/check if should go each turn from last till find?
                    // MARK: create aux function for above
                    if let lastTurn = game.getHistory().runner.last, !lastTurn.getMoves().contains(where: { $0.to == Coordinate(x: i, y: j)}) {
                        let minValue = minimax(game: game, depth: depth - 1, isMaximizing: true, currentPlayer: opponent)
                        minEvaluation = min(minEvaluation, minValue)
                    }
                }
            }

            return minEvaluation
        }
    }
}
