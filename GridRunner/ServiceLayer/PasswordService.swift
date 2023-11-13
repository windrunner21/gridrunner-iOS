//
//  PasswordService.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 10.07.23.
//

import Foundation

struct PasswordService {
    private let client: ApiClientProtocol
    private let passwordURL = URL(string: BaseURL.serverless.url + URLPath.resetPassword.path)!
    
    init(client: ApiClientProtocol) {
        self.client = client
    }
    
    func resetPassword(for email: String, completion: @escaping(Response) -> Void) {
        let parameters = [URLQueryItem(name: "email", value: email)]
        
        self.client.sendRequestWithParameters(path: URLPath.resetPassword.path, method: .GET, parameters: parameters) {
            data, response, error in
            
            if let error = error {
                Log.error("Error occured in PasswordService().resetPassword(): \(error)")
                completion(.networkError)
            } else if let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data {
                print(String(data: data, encoding: .utf8)!)
                completion(.success)
            } else {
                Log.error("Error occured in PasswordService().resetPassword(): Incorrect request.")
                completion(.requestError)
            }
        }
    }
}
