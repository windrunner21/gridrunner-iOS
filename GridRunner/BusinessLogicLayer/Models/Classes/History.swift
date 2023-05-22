//
//  History.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 22.05.23.
//

class History {
    private var runnerHistory: [Turn] = []
    private var seekerHistory: [Turn] = []
    
    func getHistory() -> (runnerHistory: [Turn], seekerHistory: [Turn]) {
        (self.runnerHistory, self.seekerHistory)
    }
    
    func getRunnerHistory() -> [Turn] {
        self.runnerHistory
    }
    
    func getSeekerHistory() -> [Turn] {
        self.seekerHistory
    }
    
    func setRunnerHistory(to history: [Turn]) {
        self.runnerHistory = history
    }
    
    func setSeekerHistory(to history: [Turn]) {
        self.seekerHistory = history
    }
    
    func appendRunnerHistory(with history: [Turn]) {
        self.runnerHistory += history
    }
    
    func appendSeekerHistory(with history: [Turn]) {
        self.seekerHistory += history
    }
}
