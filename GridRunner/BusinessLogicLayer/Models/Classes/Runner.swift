//
//  Runner.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 12.05.23.
//


class Runner: Player {
    var type: PlayerType = .runner
    var didWin: Bool = false
    
    var maximumNumberOfMoves: Int = 2
    var numberOfMoves: Int = 2
    var movesHistory: History = []
    
    var position: Coordinate
    
    private var movesHistoryWithDirection: HistoryWithDirection = [:]
    
    init(at position: Coordinate) {
        self.position = position
        // On creating Runner with initial position, add this position as root element of history.
        movesHistory.append(position)
        movesHistoryWithDirection[position] = .unknown
    }
    
    func incrementNumberOfMoves() {
        self.numberOfMoves += 1
    }
    
    func updateNumberOfMoves(to value: Int) {
        self.numberOfMoves = value
    }
    
    func updateMaximumNumberOfMoves(to maximumValue: Int) {
        self.maximumNumberOfMoves = maximumValue
    }
    
    func updateMovesHistory(with history: History) {
        self.movesHistory = history
    }
    
    func updateHistoryWithDirections(at position: Coordinate, moving direction: MoveDirection) {
        self.movesHistoryWithDirection[position] = direction
    }
    
    func getHistoryWithDirections() -> HistoryWithDirection {
        self.movesHistoryWithDirection
    }
    
    func move(to coordinate: Coordinate) {
        if numberOfMoves > 0 {
            numberOfMoves -= 1
            print("Runner is moving to x: \(coordinate.x) and y: \(coordinate.y)")
            self.position = coordinate
            self.movesHistory.append(coordinate)
        }
    }
    
    func undo() {
        numberOfMoves += 1
        let positionToRemove = self.position
        
        self.movesHistory.removeLast()
        self.movesHistoryWithDirection[positionToRemove] = nil
        
        guard let previousPosition = movesHistory.last else { return }
        self.position = previousPosition
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
