//
//  Seeker.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 12.05.23.
//

class Seeker: Player {
    var type: PlayerType = .seeker
    
    var maximumNumberOfMoves: Int = 1
    var numberOfMoves: Int = 1
    var movesHistory: History = []
    
    var didWin: Bool = false
    
    func incrementNumberOfMoves() {
        self.numberOfMoves += 1
    }
    
    func updateNumberOfMoves(to value: Int) {
        self.numberOfMoves = value
    }
    
    func updateMaximumNumberOfMoves(to maximumValue: Int) {
        self.maximumNumberOfMoves = maximumValue
    }
    
    func updateMovesHistory(with history: History) {
        self.movesHistory = history
    }
    
    func move(to coordinate: Coordinate) {
        if numberOfMoves > 0 {
            numberOfMoves -= 1
            print("Seeker is opening tile at x: \(coordinate.x) and y: \(coordinate.y)")
            movesHistory.append(coordinate)
        }
    }
    
    func undo() {
        numberOfMoves += 1
        self.movesHistory.removeLast()
    }
    
    func win() {
        didWin = true
    }
}
