//
//  Player.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 23.05.23.
//

class Player {
    var didWin: Bool = false
    
    var currentTurnNumber: Int = 0
    
    var numberOfMoves: Int = 0
    var maximumNumberOfMoves: Int = 0
    
    var history: [Turn] = []
    
    var position: Coordinate
    
    init(at position: Coordinate) {
        self.position = position
    }
    
    // MARK: Class manipulation functions
    // Updates current turn if history existed before
    func updateCurrentTurn(to value: Int) {
        self.currentTurnNumber = value
    }
    
    // Handle number of moves related properties
    func updateNumberOfMoves(to value: Int) {
        self.numberOfMoves = value
    }
    
    func updateMaximumNumberOfMoves(to value: Int) {
        self.maximumNumberOfMoves = value
    }
    
    // Handle history related properties
    func setHistory(to history: [Turn]) {
        self.history = history
    }
    
    func appendHistory(with history: [Turn]) {
        self.history += history
    }
    
    // MARK: Gameplay functions
    func createTurn(with moves: [Move]) {
        let newTurn: Turn = Turn(moves: moves)
        self.history.append(newTurn)
    }
    
    func finish() {
        self.currentTurnNumber += 1
        self.numberOfMoves += 1
        self.maximumNumberOfMoves = 1
    }
    
    func undo(_ move: Move) {
        self.position = move.from
        self.history.last?.removeLastMove()
        numberOfMoves += 1
    }
    
    // MARK: Auxiliary functions
    func movesExist() -> Bool {
        self.numberOfMoves > 0
    }
    
    func outputHistory() {
        for (index, turn) in self.history.enumerated() {
            print("\nTURN #\(index + 1)\n")
            for (index, move) in turn.getMoves().enumerated() {
                print("Move #\(index + 1): moving from \(move.from) to \(move.to) ")
            }
        }
    }
}
