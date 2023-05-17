//
//  GameHistory.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 17.05.23.
//

class GameHistory {
    typealias History = [Coordinate]
    typealias GameHistory = (runner: History, seeker: History)
    
    private var runnerHistory: [Coordinate]
    private var seekerHistory: [Coordinate]
    
    init(runnerHistory: [Coordinate], seekerHistory: [Coordinate]) {
        self.runnerHistory = runnerHistory
        self.seekerHistory = seekerHistory
    }
    
    func updateRunnerHistory(with history: History) {
        self.runnerHistory = history
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
    
    func getSeekerHistory() -> History {
        self.seekerHistory
    }
}
