//
//  Seeker.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 12.05.23.
//

class Seeker: Player {
    var type: PlayerType = .seeker
    var numberOfMoves: Int = 1
    var movesHistory: [Coordinate] = []
    var didWin: Bool = false
    
    func move(to coordinate: Coordinate) {
        if numberOfMoves > 0 {
            numberOfMoves -= 1
            print("Seeker is opening tile at x: \(coordinate.x) and y: \(coordinate.y)")
        }
    }
    
    func win() {
        didWin = true
    }
}
