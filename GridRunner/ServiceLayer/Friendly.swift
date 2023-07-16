//
//  Friendly.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 17.07.23.
//

import Foundation

class Friendly: ResponseParser, Decodable {
    static let shared = Friendly()
    
    var roomCode: String?
    var host: String?
    
    private override init() {
        self.roomCode = String()
        self.host = String()
    }
    
    func setRoomCode(_ roomCode: String?) {
        self.roomCode = roomCode
    }
    
    func setHost(_ host: String?) {
        self.host = host
    }
}
