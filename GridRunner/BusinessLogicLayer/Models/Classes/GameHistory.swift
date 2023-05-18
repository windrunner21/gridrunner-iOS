//
//  GameHistory.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 17.05.23.
//

class GameHistory {
    typealias History = [Coordinate]
    typealias GameHistory = (runner: History, seeker: History)
    typealias HistoryWithDirection = [Coordinate: MoveDirection]
    
    private var runnerHistory: [Coordinate]
    private var seekerHistory: [Coordinate]
    
    private var runnerHistoryWithDirection: HistoryWithDirection = [:]
    
    init(runnerHistory: [Coordinate], seekerHistory: [Coordinate]) {
        self.runnerHistory = runnerHistory
        self.seekerHistory = seekerHistory
    }
    
    func updateRunnerHistory(with history: History) {
        self.runnerHistory = history
    }
    
    func updateRunnerHistoryWithDirection(at position: Coordinate, moving direction: MoveDirection) {
        self.runnerHistoryWithDirection[position] = direction
    }
    
    func updateSeekerHistory(with history: History) {
        self.seekerHistory = history
    }
    
    func getGameHistory() -> GameHistory {
        (self.runnerHistory, self.seekerHistory)
    }
    
    func getRunnerHistory() -> History {
        self.runnerHistory
    }
    
    func getRunnerHistoryWithDirection() -> HistoryWithDirection {
        self.runnerHistoryWithDirection
    }
    
    func getSeekerHistory() -> History {
        self.seekerHistory
    }
    
    func convertRunnerHistoryToHistoryWithDirection() {
        for (index, move) in self.runnerHistory.enumerated() {
            if index - 1 >= 0 {
                self.runnerHistoryWithDirection[move] = identifyMovingDirection(from: runnerHistory[index - 1], to: move)
            } else {
                self.runnerHistoryWithDirection[move] = .unknown
            }
        }
    }
    
    private func identifyMovingDirection(from oldPosition: Coordinate, to newPosition: Coordinate) -> MoveDirection {
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
