//
//  GameSessionDetails.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 16.06.23.
//

import Foundation

class GameSessionDetails: CustomStringConvertible {
    
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
    
    private init(roomCode: String, runner: String, seeker: String) {
        self.roomCode = roomCode
        self.runner = runner
        self.seeker = seeker
    }
    
    func update(with details: GameSessionDetails) {
        self.roomCode = details.roomCode
        self.runner = details.runner
        self.seeker = details.seeker
    }
    
    static func decode(data: [String: Any]) -> GameSessionDetails? {
        // Extract the necessary values from the data dictionary
        guard let roomCode = data["roomCode"] as? String, let runner = data["runner"] as? String, let seeker = data["seeker"] as? String else {
            return nil
        }
        
        return GameSessionDetails(roomCode: roomCode, runner: runner, seeker: seeker)
    }
}
