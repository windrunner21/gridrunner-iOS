//
//  Seeker.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 12.05.23.
//

class Seeker: Player, AnyPlayer {
    var type: PlayerType = .seeker
    
    override init(at position: Coordinate) {
        super.init(at: position)
        
        self.updateNumberOfMoves(to: GameConfig.shared.seekerMovesLeft)
        self.updateMaximumNumberOfMoves(to: GameConfig.shared.seekerMovesLeft)
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
                
                print("Tile has been opened by Runner: \(newTile.hasBeenOpened().byRunner ).\n Has been opened by Seeker: \(newTile.hasBeenOpened().bySeeker ).")
                
                if self.currentTurnNumber > self.history.count {
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
    
    func finish(on tile: Tile, with runnerHistory: [Turn]) {        
        // If it is the last one in the Runner's history - Seeker wins.
        if self.position == runnerHistory.last?.getMoves().last?.to {
            print("i have found you - from runner history - last")
            self.didWin = true
            tile.decorateSeekerWin()
        }
    }
}
