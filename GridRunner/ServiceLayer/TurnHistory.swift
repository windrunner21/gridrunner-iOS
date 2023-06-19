//
//  TurnHistory.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 19.06.23.
//

import Foundation

class TurnHistory: ResponseParser, Decodable, CustomStringConvertible {
    var runnerHistory: [String]
    var seekerHistory: [String]
    
    var description: String {
        "Turn history initialized with runner history as: \(runnerHistory) and seeker history as: \(seekerHistory)"
    }
    
    override init() {
        self.runnerHistory = []
        self.seekerHistory = []
    }
    
    private init(runnerHistory: [String], seekerHistory: [String]) {
        self.runnerHistory = runnerHistory
        self.seekerHistory = seekerHistory
    }
    
    func update(with history: TurnHistory) {
        self.runnerHistory = history.runnerHistory
        self.seekerHistory = history.seekerHistory
    }
}
