//
//  History.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 22.05.23.
//

class History {
    private var runnerHistory: [Turn]
    private var seekerHistory: [Turn]
    
    convenience init() {
        self.init(with: [], and: [])
    }
    
    init(with runnerHistory: [Turn], and seekerHistory: [Turn]) {
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
    
    func setRunnerHistory(to history: [Turn]) {
        self.runnerHistory = history
    }
    
    func setSeekerHistory(to history: [Turn]) {
        self.seekerHistory = history
    }
    
    func appendHistory(of player: AnyPlayer, with history: [Turn]) {
        if player.type == .runner {
            self.appendRunnerHistory(with: history)
        } else {
            self.appendSeekerHistory(with: history)
        }
    }
    
    func appendRunnerHistory(with history: [Turn]) {
        self.runnerHistory += history
    }
    
    func appendSeekerHistory(with history: [Turn]) {
        self.seekerHistory += history
    }
    
    func historyContains(coordinate: Coordinate, of playerType: PlayerType) -> Bool {
        switch playerType {
        case .runner:
            for turn in self.runnerHistory {
                for move in turn.getMoves() {
                    if coordinate == move.to {
                        return true
                    }
                }
            }
            return false
        case .seeker:
            for turn in self.seekerHistory {
                for move in turn.getMoves() {
                    if coordinate == move.to {
                        return true
                    }
                }
            }
            return false
        }
    }
}
