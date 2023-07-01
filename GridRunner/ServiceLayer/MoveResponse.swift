//
//  MoveResponse.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 01.07.23.
//

import Foundation

class MoveResponse: ResponseParser, Decodable {
    static let shared = MoveResponse()
    
    private var moves: [SLMove]?
    private var playedBy: String
    
    private override init() {
        self.moves = nil
        self.playedBy = String()
    }
    
    private init(playedBy: String, moves: [SLMove]?) {
        self.playedBy = playedBy
        self.moves = moves
    }
    
    func update(with response: MoveResponse) {
        self.moves = response.moves
        self.playedBy = response.playedBy
    }
    
    func getNextTurn() -> PlayerType {
        self.playedBy == "runner" ? .seeker : .runner
    }
}
