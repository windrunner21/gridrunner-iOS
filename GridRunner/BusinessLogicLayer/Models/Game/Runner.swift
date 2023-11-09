//
//  Runner.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 12.05.23.
//

class Runner: Player, AnyPlayer {
    var type: PlayerType = .runner
    var highlightedCoordinates: Set<Coordinate> = Set()

    override init(at position: Coordinate) {
        super.init(at: position)
        
        self.updateNumberOfMoves(to: GameConfig.shared.runnerMovesLeft)
        self.updateMaximumNumberOfMoves(to: GameConfig.shared.runnerMovesLeft)
    }
    
    func getPossibleMoveCoordinates() -> Set<Coordinate> {
        highlightedCoordinates.removeAll()
        
        if self.numberOfMoves > 0 {
            let left = Coordinate(x: self.position.x - 1, y: self.position.y)
            let up = Coordinate(x: self.position.x, y: self.position.y + 1)
            let right = Coordinate(x: self.position.x + 1, y: self.position.y)
            let down = Coordinate(x: self.position.x, y: self.position.y - 1)
            
            highlightedCoordinates.insert(left)
            highlightedCoordinates.insert(up)
            highlightedCoordinates.insert(right)
            highlightedCoordinates.insert(down)
        }
        
        return highlightedCoordinates
    }
    
    func getNoLongerPossibleMoveCoordinates() -> Set<Coordinate> {
        return highlightedCoordinates
    }
    
    func move(from oldTile: Tile? = nil, to newTile: Tile) {
        if self.movesExist() {
            // Setup upcoming new move.
            let newMove = Move(from: self.position, to: newTile.position)

            // Check whether new move can be allowed to be made and direction is correct.
            let allowedMove = newMove.canRunnerMoveBeAllowed()
            let direction: MoveDirection = newMove.identifyMoveDirection()
            
            if allowedMove && direction != .unknown {
                print("Runner moved to position: \(newTile.position)")
        
                newTile.openByRunner(explicit: true, lastTurn: self.getLastTurn(), oldTile: oldTile, and: direction)
                
                print("Tile has been opened by Runner: \(newTile.hasBeenOpened().byRunner ).\n Has been opened by Seeker: \(newTile.hasBeenOpened().bySeeker ).")
                
                if self.currentTurnNumber > self.history.count {
                    self.createTurn(with: [newMove])
                } else {
                    self.history.last?.appendMove(newMove)
                }
                
                self.position = newTile.position
                self.numberOfMoves -= 1
            } else {
                print("Runner move: \(newMove) cannot be allowed.")
            }
        } else {
            print("No more moves left for Runner.")
        }
    }
    
    func publishTurn() {
        var movesArray: [[String: Any]] = []
        
        // Current turn was already incremented (-1). Array start at 0 (-1).
        for move in self.history[currentTurnNumber - 2].getMoves() {
            movesArray.append([
                "type": "moveTo",
                "from": [
                    "x": move.from.x,
                    "y": move.from.y
                ],
                "to": [
                    "x": move.to.x,
                    "y": move.to.y
                ]
            ])
        }
        
        let moves: [String: Any] = ["moves": movesArray]
        
        // Send move data to Ably.
        AblyService.shared.send(moves: moves)
    }
    
    func undo(previousTile tile: Tile?) {
        guard tile?.type != .start else { return }
        tile?.decorateRunner()
    }

    private func getLastTurn() -> Turn? {
        // Handle case for if last turn is empty, then access last move from previous turn
        if let lastTurn = self.history.last, lastTurn.getMoves().isEmpty && self.history.count >= 2 {
            return self.history[self.history.count - 2]
        } else {
            return self.history.last
        }
    }
    
    func win(on tile: Tile) {
        self.didWin = true
        tile.decorateRunnerWin()
    }
}
