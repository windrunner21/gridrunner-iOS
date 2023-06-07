//
//  User.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 05.06.23.
//

import Foundation

class User: Decodable, CustomStringConvertible {
    var id: Int
    var uuid: String
    var email: String
    var username: String
    var role: UserRole
    var runnerElo: Int
    var seekerElo: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case uuid
        case email
        case username
        case role
        case runnerElo = "runner_elo"
        case seekerElo = "seeker_elo"
    }
    
    var description: String {
        return "User (id: \(id), uuid: \(uuid)) with email: \(email) and username: \(username). Has runner elo of \(runnerElo) and seeker elo of \(seekerElo). Role: \(role)"
    }
    
    init(id: Int, uuid: String, email: String, username: String, role: UserRole, runnerElo: Int, seekerElo: Int) {
        self.id = id
        self.uuid = uuid
        self.email = email
        self.username = username
        self.role = role
        self.runnerElo = runnerElo
        self.seekerElo = seekerElo
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
