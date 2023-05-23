//
//  Player.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 12.05.23.
//

protocol Player {
    // Self related properties
    var type: PlayerType { get }
    var didWin: Bool { get set }
    
    // Turn related properties
    var currentTurn: Int { get }
    
    // Number of moves related properties
    var numberOfMoves: Int { get }
    var maximumNumberOfMoves: Int { get }
    
    // History related properties
    var history: [Turn] { get }
    
    // Position of the Player at any given moment.
    var position: Coordinate { get }
    
    // Number of moves manipulation
    func updateNumberOfMoves(to value: Int)
    func updateMaximumNumberOfMoves(to value: Int)
    
    // History manipulation
    func setHistory(to history: [Turn])
    func appendHistory(with history: [Turn])
    
    // Self actions
    func move(from oldTile: Tile?, to newTile: Tile)
    
    // Button clicks
    func finish(on tile: Tile)
    func undo(_ move: Move, returnTo tile: Tile?)
}
