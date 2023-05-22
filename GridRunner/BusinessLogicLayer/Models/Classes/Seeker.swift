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
    
    var history: [Turn] = []
    
    func updateNumberOfMoves(to value: Int) {
        self.numberOfMoves = value
    }
    
    func setHistory(to history: [Turn]) {
        self.history = history
    }
    
    func appendHistory(with history: [Turn]) {
        self.history += history
    }
    
    func move(to tile: Tile) {
        if numberOfMoves > 0 {
            numberOfMoves -= 1
            print("Seeker is opening tile at: \(tile.position)")
            tile.openBySeeker(explicit: true)
            history.last?.appendMove(Move(from: tile.position, to: tile.position))
        }
    }
    
    func win() {
        didWin = true
    }
    
    func finish(on tile: Tile) {
        self.currentTurn += 1
        self.numberOfMoves += 1
    }
    
    func undo() {
        self.history.last?.removeLastMove()
        numberOfMoves += 1
    }
}
