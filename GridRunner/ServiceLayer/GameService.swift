//
//  GameService.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 05.06.23.
//

import Foundation

class GameService {
    private let client = APIClient(baseURL: .gameServer)
    
    func createRoom(as role: String, withId clientId: String, completion: @escaping (Response) -> Void) {
        client.sendRequest(
            path: URLPath.createRoom.path,
            method: .GET,
            headers: ["as": role, "clientId": clientId]
        ) { data, response, error in
            
            if let error = error {
                NSLog("Error occured in GameService().createRoom(): \(error)")
                completion(.networkError)
            } else if let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data {
                print(String(data: data, encoding: .utf8)!)
                completion(.success)
            } else {
                NSLog("Error occured in GameService().createRoom(): Incorrect request.")
                completion(.requestError)
            }
        }
    }
    
    func joinRoom(withCode code: String, completion: @escaping (Response) -> Void) {
        client.sendRequest(
            path: URLPath.joinRoom.path,
            method: .GET,
            headers: ["room": code]
        ) { data, response, error in
            
            if let error = error {
                NSLog("Error occured in GameService().joinRoom(): \(error)")
                completion(.networkError)
            } else if let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data {
                print(String(data: data, encoding: .utf8)!)
                completion(.success)
            } else {
                NSLog("Error occured in GameService().joinRoom(): Incorrect request.")
                completion(.requestError)
            }
        }
    }
}
