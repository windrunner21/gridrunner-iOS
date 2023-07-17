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
            parameters: [URLQueryItem(name: "as", value: role), URLQueryItem(name: "clientId", value: clientId)]
        ) { data, response, error in
            
            if let error = error {
                NSLog("Error occured in GameService().createRoom(): \(error)")
                completion(.networkError)
            } else if let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data {
                print(String(data: data, encoding: .utf8)!)
                let friendly = Friendly.decode(data: data, type: Friendly.self)
                
                if let friendly = friendly {
                    Friendly.shared.setRoomCode(friendly.getRoomCode())
                    completion(.success)
                } else {
                    NSLog("Error occured in GameService().createRoom(): Cannot decode JSON to Friendly class.")
                    completion(.decoderError)
                }
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
            parameters: [URLQueryItem(name: "room", value: code)]
        ) { data, response, error in
            
            if let error = error {
                NSLog("Error occured in GameService().joinRoom(): \(error)")
                completion(.networkError)
            } else if let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data {
                print(String(data: data, encoding: .utf8)!)
                let friendly = Friendly.decode(data: data, type: Friendly.self)
                
                if let friendly = friendly {
                    Friendly.shared.setHost(friendly.getHost())
                    completion(.success)
                } else {
                    NSLog("Error occured in GameService().joinRoom(): Cannot decode JSON to Friendly class.")
                    completion(.decoderError)
                }
            } else {
                NSLog("Error occured in GameService().joinRoom(): Incorrect request.")
                completion(.requestError)
            }
        }
    }
}
