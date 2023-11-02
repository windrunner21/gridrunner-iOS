//
//  History.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 22.05.23.
//

class History: HistoryProtocol {
    var runner: [Turn]
    var seeker: [Turn]
    
    convenience init() {
        self.init(with: [], and: [])
    }
    
    init(with runnerHistory: [Turn], and seekerHistory: [Turn]) {
        self.runner = runnerHistory
        self.seeker = seekerHistory
    }
    
    func getRunnerHistory() -> [Turn] {
        self.runner
    }
    
    func getSeekerHistory() -> [Turn] {
        self.seeker
    }
    
    func setHistory(of player: PlayerType, to history: [Turn]) {
        if player == .runner {
            self.setRunnerHistory(to: history)
        } else {
            self.setSeekerHistory(to: history)
        }
    }
    
    func setRunnerHistory(to history: [Turn]) {
        self.runner = history
    }
    
    func setSeekerHistory(to history: [Turn]) {
        self.seeker = history
    }
    
    func appendHistory(of player: AnyPlayer, with history: [Turn]) {
        if player.type == .runner {
            self.appendRunnerHistory(with: history)
        } else {
            self.appendSeekerHistory(with: history)
        }
    }
    
    func appendRunnerHistory(with history: [Turn]) {
        self.runner += history
    }
    
    func appendRunnerHistory(with turn: Turn) {
        self.runner.append(turn)
    }
    
    func appendSeekerHistory(with history: [Turn]) {
        self.seeker += history
    }
    
    func appendSeekerHistory(with turn: Turn) {
        self.seeker.append(turn)
    }
    
    // MARK: History output methods
    func outputHistory() {
        print("Outputting Game's History.")
        self.outputRunnerHistory()
        self.outputSeekerHistory()
    }
    
    func outputRunnerHistory() {
        print("\nRunner History:")
        for (index, turn) in runner.enumerated() {
            print("\nTURN #\(index + 1)\n")
            for (index, move) in turn.getMoves().enumerated() {
                print("Move #\(index + 1): moving from \(move.from) to \(move.to) ")
            }
        }
    }
    
    func outputSeekerHistory() {
        print("\nSeeker History:")
        for (index, turn) in seeker.enumerated() {
            print("\nTURN #\(index + 1)\n")
            for (index, move) in turn.getMoves().enumerated() {
                print("Move #\(index + 1): moving from \(move.from) to \(move.to) ")
            }
        }
    }
}
