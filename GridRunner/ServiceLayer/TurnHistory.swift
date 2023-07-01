//
//  TurnHistory.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 19.06.23.
//

import Foundation

class TurnHistory: ResponseParser, Decodable, CustomStringConvertible {
    var runnerHistory: [SLMove]
    var seekerHistory: [SLMove]
    
    var description: String {
        "Turn history initialized with runner history as: \(runnerHistory) and seeker history as: \(seekerHistory)"
    }
    
    override init() {
        self.runnerHistory = []
        self.seekerHistory = []
    }
    
    // TODO: implement this method.
    func toHistory() -> History {
        return History(with: [], and: [])
    }
}
