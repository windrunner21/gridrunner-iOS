//
//  Player.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 12.05.23.
//

protocol Player {
    var type: PlayerType { get }
    var numberOfMoves: Int { get set }
    var movesHistory: [String] { get set }
    var didWin: Bool { get set }
    
    func move(to coordinate: Coordinate)
    func win()
}
