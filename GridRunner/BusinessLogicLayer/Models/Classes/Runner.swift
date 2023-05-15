//
//  Runner.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 12.05.23.
//


class Runner: Player {
    var type: PlayerType = .runner
    var didWin: Bool = false
    
    var numberOfMoves: Int = 2
    var movesHistory: History = []
    
    var position: Coordinate
    
    init(at position: Coordinate) {
        self.position = position
    }
    
    func move(to coordinate: Coordinate) {
        if numberOfMoves > 0 {
            numberOfMoves -= 1
            print("Runner is moving to x: \(coordinate.x) and y: \(coordinate.y)")
            self.position = coordinate
            self.movesHistory.append(coordinate)
        }
    }
    
    func win() {
        didWin = true
    }
    
    func canMoveBeAllowed(from oldPosition: Coordinate, to newPosition: Coordinate) -> Bool {        
        let isCorrectHorizontalMove = abs(newPosition.y - oldPosition.y) == 1 && newPosition.x == oldPosition.x
        let isCorrectVerticalMove = abs(newPosition.x - oldPosition.x) == 1 && newPosition.y == oldPosition.y
        
        return isCorrectHorizontalMove || isCorrectVerticalMove
    }
    
    func identifyMovingDirection(from oldPosition: Coordinate, to newPosition: Coordinate) -> MoveDirection {
        // horizontal movement
        // left
        if oldPosition.x == newPosition.x && oldPosition.y > newPosition.y {
            return .left
        }
        // right
        if oldPosition.x == newPosition.x && oldPosition.y < newPosition.y {
            return .right
        }
        
        // vertical movement
        // up
        if oldPosition.x > newPosition.x && oldPosition.y == newPosition.y {
            return .up
        }
        // down
        if oldPosition.x < newPosition.x && oldPosition.y == newPosition.y {
            return .down
        }
        
        return .unknown
    }
}
