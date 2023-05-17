//
//  Player.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 12.05.23.
//

protocol Player {
    typealias History = [Coordinate]
    typealias HistoryWithDirection = [Coordinate: MoveDirection]
    
    var type: PlayerType { get }

    var maximumNumberOfMoves: Int { get set }
    var numberOfMoves: Int { get set }
    var movesHistory: History { get set }
    
    var didWin: Bool { get set }
    
    func updateMaximumNumberOfMoves(to maximumValue: Int)
    func move(to coordinate: Coordinate)
    func undo()
    func win()
}
