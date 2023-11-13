//
//  AblyService.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 13.06.23.
//

import Foundation

struct AblyJWTService {
    let client: ApiClientProtocol
    
    init(client: ApiClientProtocol) {
        self.client = client
    }
    
    func getJWT(completion: @escaping (Response, String?)->Void) {
        let cookies = (name: "gridrun-session", value: UserDefaults.standard.value(forKey: "session") as? String)
        
        self.client.sendRequestWithCookies(path: "/channels/auth", method: .GET, cookies: cookies) {
            data, response, error in
            
            if let error = error {
                Log.error("Error occured in AblyService().getJWT(): \(error)")
                completion(.networkError, nil)
            } else if let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data {
                let token = String(decoding: data, as: UTF8.self)
                completion(.success, token.replacingOccurrences(of: "\"", with: ""))
            } else {
                Log.error("Error occured in AblyService().getJWT(): Sent request was incorrect.")
                completion(.requestError, nil)
            }
        }
    }
}
