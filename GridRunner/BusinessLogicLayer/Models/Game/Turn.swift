//
//  Turn.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 22.05.23.
//

class Turn {
    private var moves: [Move]
    var id: Int
    
    init(moves: [Move]) {
        self.moves = moves
        self.id = Int.random(in: Int.min..<Int.max)
    }
    
    func setMoves(to moves: [Move]) {
        self.moves = moves
    }
    
    func appendMoves(with moves: [Move]) {
        self.moves += moves
    }
    
    func removeLastMove() {
        self.moves.removeLast()
    }
    
    func appendMove(_ move: Move) {
        self.moves.append(move)
    }
    
    func getMoves() -> [Move] {
        self.moves
    }
    
    func reverse() {
        self.moves.reverse()
    }
}
