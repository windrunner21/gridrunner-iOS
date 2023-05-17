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
    
    func updateMaximumNumberOfMoves(to maximumValue: Int) {
        self.maximumNumberOfMoves = maximumValue
    }
    
    func move(to coordinate: Coordinate) {
        if numberOfMoves > 0 {
            numberOfMoves -= 1
            print("Seeker is opening tile at x: \(coordinate.x) and y: \(coordinate.y)")
        }
    }
    
    func undo() {
        numberOfMoves += 1
    }
    
    func win() {
        didWin = true
    }
}
