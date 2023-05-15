//
//  Runner.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 12.05.23.
//


class Runner: Player {
    var type: PlayerType = .runner
    var didWin: Bool = false
    
    var numberOfMoves: Int = 2
    var movesHistory: [String] = []
    
    var position: Coordinate
    
    init(at position: Coordinate) {
        self.position = position
    }
    
    func move(to coordinate: Coordinate) {
        if numberOfMoves > 0 {
            numberOfMoves -= 1
            print("Runner is moving to x: \(coordinate.x) and y: \(coordinate.y)")
            self.position = coordinate
        }
    }
    
    func win() {
        didWin = true
    }
}
