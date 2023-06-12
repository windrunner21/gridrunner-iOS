//
//  User.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 05.06.23.
//

import Foundation

class User: Decodable, CustomStringConvertible {
    
    static let shared = User()
    
    var id: Int
    var uuid: String
    var email: String
    var username: String
    var role: UserRole
    var runnerElo: Int
    var seekerElo: Int
    var isLoggedIn: Bool
    
    var description: String {
        return "User (id: \(id), uuid: \(uuid)) with email: \(email) and username: \(username). Has runner elo of \(runnerElo) and seeker elo of \(seekerElo). Role: \(role). Logged in: \(isLoggedIn)."
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case uuid
        case email
        case username
        case role
        case runnerElo = "runner_elo"
        case seekerElo = "seeker_elo"
        case isLoggedIn
    }
    
    private init() {
        self.id = -1
        self.uuid = String()
        self.email = String()
        self.username = String()
        self.role = .UNKNOWN
        self.runnerElo = Int()
        self.seekerElo = Int()
        self.isLoggedIn = false
    }
    
    func update(with decodedUser: User) {
        self.id = decodedUser.id
        self.uuid = decodedUser.uuid
        self.email = decodedUser.email
        self.username = decodedUser.username
        self.role = decodedUser.role
        self.runnerElo = decodedUser.runnerElo
        self.seekerElo = decodedUser.seekerElo
        self.isLoggedIn = decodedUser.isLoggedIn
    }
    
    func remove() {
        self.id = -1
        self.uuid = String()
        self.email = String()
        self.username = String()
        self.role = .UNKNOWN
        self.runnerElo = Int()
        self.seekerElo = Int()
        self.isLoggedIn = false
    }
    
    static func decode(data: Data) -> User? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(User.self, from: data)
            return decodedData
        } catch {
            print("Error decoding JSON: \(error)")
        }
        
        return nil
    }
}
