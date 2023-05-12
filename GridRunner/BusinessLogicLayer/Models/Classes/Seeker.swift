//
//  Seeker.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 12.05.23.
//

import Foundation

class Seeker: Player {
    var numberOfMoves: Int = 1
    var movesHistory: [String] = []
    var didWin: Bool = false
    
    func move(to coordinate: Coordinate) {
        print("Seeker is moving to x: \(coordinate.x) and y: \(coordinate.y)")
    }
    
    func win() {
        didWin = true
    }
    
    func didPlayerWin() -> Bool {
        didWin
    }
}
