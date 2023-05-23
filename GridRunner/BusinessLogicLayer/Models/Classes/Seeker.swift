//
//  Seeker.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 12.05.23.
//

class Seeker: Player {
    var type: PlayerType = .seeker
    var didWin: Bool = false
    
    var currentTurn: Int = 1
    
    var numberOfMoves: Int = 1
    var maximumNumberOfMoves: Int = 1
    
    var history: [Turn] = []
    
    var position: Coordinate = Coordinate(x: -1, y: -1)
    
    func updateNumberOfMoves(to value: Int) {
        self.numberOfMoves = value
    }
    
    func updateMaximumNumberOfMoves(to value: Int) {
        self.maximumNumberOfMoves = value
    }
    
    
    func setHistory(to history: [Turn]) {
        self.history = history
    }
    
    func appendHistory(with history: [Turn]) {
        self.history += history
    }
    
    func move(from oldTile: Tile? = nil, to newTile: Tile) {
        if numberOfMoves > 0 {
            numberOfMoves -= 1
            print("Seeker is opening tile at: \(newTile.position)")
            newTile.openBySeeker(explicit: true)
            history.last?.appendMove(Move(from: newTile.position, to: newTile.position))
        }
    }
    
    func finish(on tile: Tile) {
        self.currentTurn += 1
        self.numberOfMoves += 1
    }
    
    func undo(_ move: Move, returnTo tile: Tile?) {
        self.history.last?.removeLastMove()
        numberOfMoves += 1
    }
}
