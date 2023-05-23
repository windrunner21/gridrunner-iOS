//
//  Runner.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 12.05.23.
//


class Runner: Player {
    var type: PlayerType = .runner
    var didWin: Bool = false
    
    var currentTurn: Int = 1
    
    var numberOfMoves: Int = 2
    var maximumNumberOfMoves: Int = 2
    
    var history: [Turn] = []
    
    var position: Coordinate
    
    init(at position: Coordinate) {
        self.position = position
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
            let allowedMove = newMove.canMoveBeAllowed()
            let direction: MoveDirection = newMove.identifyMoveDirection()
            
            if allowedMove && direction != .unknown {
                print("Runner moved to position: \(newTile.position)")
        
                newTile.openByRunner(explicit: true)
                
                let lastTurn = self.getLastTurn()
                newTile.updateDirectionImage(to: direction,
                                             from: lastTurn?.getMoves().last?.identifyMoveDirection(),
                                             oldTile: oldTile)
                
                if currentTurn > self.history.count {
                    self.createTurn(with: [newMove])
                } else {
                    self.history.last?.appendMove(newMove)
                }
                
                self.position = newTile.position
                
                numberOfMoves -= 1
            } else {
                print("Runner move: \(newMove) cannot be allowed.")
            }
        } else {
            print("No more moves left for Runner.")
        }
    }
    
    func finish(on tile: Tile) {
        self.currentTurn += 1
        self.numberOfMoves += 1
        self.maximumNumberOfMoves = 1
        
        if tile.type == .exit {
            self.didWin = true
            tile.decorateRunnerWin()
        }
    }
    
    func undo(_ move: Move, returnTo tile: Tile? = nil) {
        self.position = move.from
        self.history.last?.removeLastMove()
        self.numberOfMoves += 1
        
        let lastTurn = self.getLastTurn()
        tile?.updateDirectionImageOnUndo(to: lastTurn?.getMoves().last?.identifyMoveDirection() ?? .unknown)
    }
    
    private func createTurn(with moves: [Move]) {
        let newTurn: Turn = Turn(moves: moves)
        self.history.append(newTurn)
    }
    
    private func movesExist() -> Bool {
        self.numberOfMoves > 0
    }
    
    private func getLastTurn() -> Turn? {
        // Handle case for if last turn is empty, then access last move from previous turn
        if let lastTurn = self.history.last, lastTurn.getMoves().isEmpty && self.history.count >= 2 {
            return self.history[self.history.count - 2]
        } else {
            return self.history.last
        }
    }
}
