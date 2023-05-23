//
//  History.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 22.05.23.
//

class History {
    private var runnerHistory: [Turn] = []
    private var seekerHistory: [Turn] = []
    
    func setHistory(runnerHistory: [Turn], seekerHistory: [Turn]) {
        self.runnerHistory = runnerHistory
        self.seekerHistory = seekerHistory
    }
    
    func getHistory() -> (runnerHistory: [Turn], seekerHistory: [Turn]) {
        (self.runnerHistory, self.seekerHistory)
    }
    
    func getRunnerHistory() -> [Turn] {
        self.runnerHistory
    }
    
    func getSeekerHistory() -> [Turn] {
        self.seekerHistory
    }
    
    func setHistory(of player: AnyPlayer, to history: [Turn]) {
        if player.type == .runner {
            self.setRunnerHistory(to: history)
        } else {
            self.setSeekerHistory(to: history)
        }
    }
    
    func appendHistory(of player: AnyPlayer, with history: [Turn]) {
        if player.type == .runner {
            self.appendRunnerHistory(with: history)
        } else {
            self.appendSeekerHistory(with: history)
        }
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
