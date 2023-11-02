//
//  GameSessionDetails.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 16.06.23.
//

import Foundation

class GameSessionDetails: AnyResponseParser, Decodable, CustomStringConvertible {
    static let shared = GameSessionDetails()
    
    var roomCode: String
    var runner: String
    var seeker: String
    
    var description: String {
        "Game Session initialized with room code: \(roomCode), runner id: \(runner), seeker id: \(seeker)"
    }
    
    private init() {
        self.roomCode = String()
        self.runner = String()
        self.seeker = String()
    }
    
    func update(with details: GameSessionDetails) {
        self.roomCode = details.roomCode
        self.runner = details.runner
        self.seeker = details.seeker
    }
    
    func setRoomCode(to roomCode: String) {
        self.roomCode = roomCode
    }
    
    func setRunner(to runner: String) {
        self.runner = runner
    }
    
    func setSeeker(to seeker: String) {
        self.seeker = seeker
    }
}
