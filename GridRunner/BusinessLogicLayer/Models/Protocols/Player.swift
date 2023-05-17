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

    var maximumNumberOfMoves: Int { get }
    var numberOfMoves: Int { get }
    var movesHistory: History { get }
    
    var didWin: Bool { get set }
    
    func incrementNumberOfMoves()
    func updateNumberOfMoves(to value: Int)
    func updateMaximumNumberOfMoves(to maximumValue: Int)
    
    func undo()
    func move(to coordinate: Coordinate)
    
    func win()
}
