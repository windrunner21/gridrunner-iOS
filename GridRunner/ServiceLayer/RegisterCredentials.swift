//
//  RegisterCredentials.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 05.06.23.
//

import Foundation

class RegisterCredentials: Credentials, Codable {
    var username: String
    var password: String
    var email: String
    
    init(username: String, password: String, email: String) {
        self.username = username
        self.password = password
        self.email = email
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
    
    func decode(data: Data) -> Credentials? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(RegisterCredentials.self, from: data)
            return decodedData
        } catch {
            print("Error decoding JSON: \(error)")
        }
        
        return nil
    }
}
