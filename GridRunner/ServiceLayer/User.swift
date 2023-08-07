//
//  User.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 05.06.23.
//

import Foundation

class User: ResponseParser, Decodable, CustomStringConvertible {
    
    static let shared = User()
    
    var id: Int
    var email: String
    var username: String
    var role: UserRole
    var runnerElo: Int
    var seekerElo: Int
    var isLoggedIn: Bool
    
    var description: String {
        "User (id: \(id)) with email: \(email) and username: \(username). Has runner elo of \(runnerElo) and seeker elo of \(seekerElo). Role: \(role). Logged in: \(isLoggedIn)."
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case username
        case role
        case runnerElo = "runner_elo"
        case seekerElo = "seeker_elo"
        case isLoggedIn
    }
    
    private override init() {
        self.id = -1
        self.email = String()
        self.username = String()
        self.role = .UNKNOWN
        self.runnerElo = Int()
        self.seekerElo = Int()
        self.isLoggedIn = false
    }
    
    func update(with decodedUser: User) {
        self.id = decodedUser.id
        self.email = decodedUser.email
        self.username = decodedUser.username
        self.role = decodedUser.role
        self.runnerElo = decodedUser.runnerElo
        self.seekerElo = decodedUser.seekerElo
        self.isLoggedIn = decodedUser.isLoggedIn
    }
}
