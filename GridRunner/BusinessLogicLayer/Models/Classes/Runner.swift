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
    
    var history: [Turn] = []
    
    var position: Coordinate
    
    init(at position: Coordinate) {
        self.position = position
    }
    
    func updateNumberOfMoves(to value: Int) {
        self.numberOfMoves = value
    }
    
    func setHistory(to history: [Turn]) {
        self.history = history
    }
    
    func appendHistory(with history: [Turn]) {
        self.history += history
    }
    
    func move(to tile: Tile) {
        if self.movesExist() {
            // Setup upcoming new move.
            let newMove = Move(from: self.position, to: tile.position)

            // Check whether new move can be allowed to be made and direction is correct.
            let allowedMove = newMove.canMoveBeAllowed()
            let direction: MoveDirection = newMove.identifyMoveDirection()
            
            if allowedMove && direction != .unknown {
                print("Runner is moving to position: \(tile.position)")
                
                tile.openByRunner(explicit: true)
                tile.updateDirectionImage(to: direction)
                
                if currentTurn > self.history.count {
                    self.createTurn(with: [newMove])
                } else {
                    self.history.last?.appendMove(newMove)
                }
                
                self.position = tile.position
                
                numberOfMoves -= 1
            } else {
                print("Runner move: \(newMove) cannot be allowed.")
            }
        } else {
            print("No more moves left for Runner.")
        }
    }
    
    func win() {
        didWin = true
    }
    
    func finish(on tile: Tile) {
        self.currentTurn += 1
        self.numberOfMoves += 1
        
        if tile.type == .exit {
            self.win()
            tile.decorateRunnerWin()
        }
    }
    
    func undo() {
        guard let previousPosition = self.history.last?.getMoves().last?.from else {
            print("Could not get previous position for Runner. Returning...")
            return
        }
        
        self.position = previousPosition
        
        self.history.last?.removeLastMove()
    
        numberOfMoves += 1
    }
    
    /// Creates turn with empty initialized Move.
    private func createTurn(with moves: [Move]) {
        let newTurn: Turn = Turn(moves: moves)
        self.history.append(newTurn)
    }
    
    private func movesExist() -> Bool {
        self.numberOfMoves > 0
    }
}
