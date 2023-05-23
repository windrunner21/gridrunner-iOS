//
//  Seeker.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 12.05.23.
//

class Seeker: AnyPlayer {
    var type: PlayerType = .seeker
    var didWin: Bool = false
    
    var currentTurn: Int = 1
    
    var numberOfMoves: Int = 1
    var maximumNumberOfMoves: Int = 1
    
    var history: [Turn] = []
    
    var position: Coordinate
    
    init(at position: Coordinate) {
        self.position = position
    }
    
    func updateCurrentTurn(to value: Int) {
        self.currentTurn = value
    }
    
    func updateNumberOfMoves(to value: Int) {
        self.numberOfMoves = value
    }
    
    func updateMaximumNumberOfMoves(to value: Int) {
        self.maximumNumberOfMoves = value
    }
    
    func setHistory(to history: [Turn]) {
        self.history = history
    }
    
    func appendHistory(with history: [Turn]) {
        self.history += history
    }
    
    func move(from oldTile: Tile? = nil, to newTile: Tile) {
        if self.movesExist() {
            // Setup upcoming new move.
            let newMove = Move(from: self.position, to: newTile.position)
            
            // Check whether new move can be allowed to be made and direction is correct.
            let allowedMove = newMove.canSeekerMoveBeAllowed()
            
            if allowedMove {
                print("Seeker moved to position: \(newTile.position)")
                
                newTile.openBySeeker(explicit: true)
                
                if self.currentTurn > self.history.count {
                    self.createTurn(with: [newMove])
                } else {
                    self.history.last?.appendMove(newMove)
                }
                
                self.position = newTile.position
                self.numberOfMoves -= 1
            } else {
                print("Seeker move: \(newMove) cannot be allowed")
            }
        } else {
            print("No more moves left for Seeker")
        }
    }
    
    func finish() {
        self.currentTurn += 1
        self.numberOfMoves += 1
        self.maximumNumberOfMoves = 1
    }
    
    func finish(on tile: Tile, with runnerHistory: [Turn]) {        
        // If it is the last one in the Runner's history - Seeker wins.
        if self.position == runnerHistory.last?.getMoves().last?.to {
            print("i have found you - from runner history - last")
            self.didWin = true
            tile.decorateSeekerWin()
        }
    }
    
    func undo(_ move: Move, returnTo tile: Tile?) {
        self.position = move.from
        self.history.last?.removeLastMove()
        numberOfMoves += 1
    }
    
    func createTurn(with moves: [Move]) {
        let newTurn: Turn = Turn(moves: moves)
        self.history.append(newTurn)
    }
    
    private func movesExist() -> Bool {
        self.numberOfMoves > 0
    }
}
