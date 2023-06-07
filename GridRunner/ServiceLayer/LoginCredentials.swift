//
//  LoginCredentials.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 05.06.23.
//

import Foundation

class LoginCredentials: Credentials, Encodable {
    var username: String
    var password: String
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    func encode() -> Data? {
        let encoder = JSONEncoder()
        
        do {
            let encodedData = try encoder.encode(self)
            return encodedData
        } catch {
            print("Error encoding request body: \(error)")
        }
        
        return nil
    }
}
