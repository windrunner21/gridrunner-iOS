//
//  GameService.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 05.06.23.
//

import Foundation

struct GameService {
    private let client: ApiClientProtocol
    
    init(client: ApiClientProtocol) {
        self.client = client
    }
    
    func createRoom(as role: String, withId clientId: String, completion: @escaping (Response) -> Void) {
        let parameters = [URLQueryItem(name: "as", value: role), URLQueryItem(name: "clientId", value: clientId)]
        
        client.sendRequestWithParameters(path: URLPath.createRoom.path, method: .GET, parameters: parameters) { 
            data, response, error in
            
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
        let parameters = [URLQueryItem(name: "room", value: code)]
        
        client.sendRequestWithParameters(path: URLPath.joinRoom.path, method: .GET, parameters: parameters) {
            data, response, error in
            
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
