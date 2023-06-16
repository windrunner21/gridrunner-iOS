//
//  AblyService.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 13.06.23.
//

import Foundation

class AblyJWTService {
    let client = APIClient(baseURL: .gameServer)
    
    func getJWT(completion: @escaping (Response, String?)->Void) {
        self.client.sendRequest(
            path: "/channels/auth",
            method: .GET,
            cookies: (name: "gridrun-session", value: UserDefaults.standard.value(forKey: "session") as? String)
        ) { data, response, error in
            
            if let error = error {
                NSLog("Error occured in AblyService().getJWT(): \(error)")
                completion(.networkError, nil)
            } else if let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data {
                let token = String(decoding: data, as: UTF8.self)
                completion(.success, token.replacingOccurrences(of: "\"", with: ""))
            } else {
                NSLog("Error occured in AblyService().getJWT(): Sent request was incorrect.")
                completion(.requestError, nil)
            }
        }
    }
}
