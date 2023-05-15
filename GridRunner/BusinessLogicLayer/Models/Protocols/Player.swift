//
//  Player.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 12.05.23.
//

protocol Player {
    typealias History = [Coordinate]
    
    var type: PlayerType { get }
    var numberOfMoves: Int { get set }
    var movesHistory: History { get set }
    var didWin: Bool { get set }
    
    func move(to coordinate: Coordinate)
    func win()
}
