//
//  UserService.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 09.06.23.
//

import Foundation

struct UserService {
    private let client: ApiClientProtocol
    private let userURL = URL(string: BaseURL.serverless.url + URLPath.user.path)!
    
    init(client: ApiClientProtocol) {
        self.client = client
    }
    
    func getUser(completion: @escaping(Response)-> Void) {
        self.client.sendRequest(path: URLPath.user.path, method: .GET) { 
            data, response, error in
            
            if let error = error {
                NSLog("Error occured in UserService().getUser(): \(error)")
                completion(.networkError)
            } else if let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data {
                let user = User.decode(data: data, type: User.self)
                
                if let user = user {
                    User.shared.update(with: user)
                    completion(.success)
                } else {
                    NSLog("Error occured in UserService().getUser(): Cannot decode JSON to User class.")
                    completion(.decoderError)
                }
                
            } else {
                NSLog("Error occured in UserService().getUser(): Sent request was incorrect.")
                completion(.requestError)
            }
        }
    }
}
