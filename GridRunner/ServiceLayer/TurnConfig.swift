//
//  TurnConfig.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 28.06.23.
//

import Foundation

class TurnConfig: ResponseParser, Decodable, CustomStringConvertible {
    static let shared = TurnConfig()
    
    var turn: String
    var description: String {
        "Turn config received. Next turn is: \(turn)'s"
    }
    
    private override init() {
        self.turn = String()
    }
    
    private init(turn: String) {
        self.turn = turn
    }
    
    func upgrade(with config: TurnConfig) {
        self.turn = config.turn
    }
    
    func upgrade(with turn: String) {
        self.turn = turn
    }
    
    func getTurn() -> PlayerType {
        return self.turn == "runner" ? .runner : .seeker
    }
}
