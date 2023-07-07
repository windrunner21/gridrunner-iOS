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
    
    func setHistory(of player: PlayerType, to history: [Turn]) {
        if player == .runner {
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
    
    func appendRunnerHistory(with turn: Turn) {
        self.runnerHistory.append(turn)
    }
    
    func appendSeekerHistory(with history: [Turn]) {
        self.seekerHistory += history
    }
    
    func appendSeekerHistory(with turn: Turn) {
        self.seekerHistory.append(turn)
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
        case .server:
            return false
        }
    }
    
    func outputRunnerHistory() {
        print("Runner History ONLY:")
        for (index, turn) in runnerHistory.enumerated() {
            print("\nTURN #\(index + 1)\n")
            for (index, move) in turn.getMoves().enumerated() {
                print("Move #\(index + 1): moving from \(move.from) to \(move.to) ")
            }
        }
    }
    
    func outputSeekerHistory() {
        print("Seeker History ONLY:")
        for (index, turn) in seekerHistory.enumerated() {
            print("\nTURN #\(index + 1)\n")
            for (index, move) in turn.getMoves().enumerated() {
                print("Move #\(index + 1): moving from \(move.from) to \(move.to) ")
            }
        }
    }
    
    func outputHistory() {
        print("Outputting Game's History.")
        print("\nRunner History:")
        for (index, turn) in runnerHistory.enumerated() {
            print("\nTURN #\(index + 1)\n")
            for (index, move) in turn.getMoves().enumerated() {
                print("Move #\(index + 1): moving from \(move.from) to \(move.to) ")
            }
        }
        
        print("\nSeeker History:")
        for (index, turn) in seekerHistory.enumerated() {
            print("\nTURN #\(index + 1)\n")
            for (index, move) in turn.getMoves().enumerated() {
                print("Move #\(index + 1): moving from \(move.from) to \(move.to) ")
            }
        }
    }
}
