//
//  Friendly.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 17.07.23.
//

import Foundation

class Friendly: AnyResponseParser, Decodable {
    static let shared = Friendly()
    
    private var roomCode: String?
    private var host: String?
    
    private init() {
        self.roomCode = String()
        self.host = String()
    }
    
    func setRoomCode(_ roomCode: String?) {
        self.roomCode = roomCode
    }
    
    func setHost(_ host: String?) {
        self.host = host
    }
    
    func getRoomCode() -> String? {
        self.roomCode
    }
    
    func getHost() -> String? {
        self.host
    }
}
