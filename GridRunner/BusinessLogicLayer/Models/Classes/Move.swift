//
//  Move.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 22.05.23.
//

class Move: CustomStringConvertible {
    var from: Coordinate
    var to: Coordinate
    
    var description: String {
        return ("Move made from: \(from) to: \(to)")
    }
    
    init(from: Coordinate, to: Coordinate) {
        self.from = from
        self.to = to
    }
    
    func identifyMoveDirection() -> MoveDirection {
        // Horizontal movement.
        if self.from.x == self.to.x && self.from.y > self.to.y {
            print("Player is moving left from \(from) to \(to)")
            return .left
        }
        if self.from.x == self.to.x && self.from.y < self.to.y {
            print("Player is moving right from \(from) to \(to)")
            return .right
        }
        
        // Vertical movement.
        if self.from.x > self.to.x && self.from.y == self.to.y {
            print("Player is moving up from \(from) to \(to)")
            return .up
        }
        if self.from.x < self.to.x && self.from.y == self.to.y {
            print("Player is moving down from \(from) to \(to)")
            return .down
        }
        
        return .unknown
    }
    
    func canMoveBeAllowed() -> Bool {
        let isCorrectHorizontalMove = abs(from.y - to.y) == 1 && from.x == to.x
        let isCorrectVerticalMove = abs(from.x - to.x) == 1 && from.y == to.y
        
        return isCorrectHorizontalMove || isCorrectVerticalMove
    }
}
