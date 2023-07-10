//
//  PasswordService.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 10.07.23.
//

import Foundation

class PasswordService {
    private let client = APIClient(baseURL: .serverless)
    private let passwordURL = URL(string: BaseURL.serverless.url + URLPath.resetPassword.path)!
    
    func resetPassword(for email: String, completion: @escaping(Response) -> Void) {
        self.client.sendRequest(
            path: URLPath.resetPassword.path,
            method: .GET,
            parameters: [URLQueryItem(name: "email", value: email)]
        ) { data, response, error in
            
            if let error = error {
                NSLog("Error occured in PasswordService().resetPassword(): \(error)")
                completion(.networkError)
            } else if let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data {
                print(String(data: data, encoding: .utf8)!)
                completion(.success)
            } else {
                NSLog("Error occured in PasswordService().resetPassword(): Incorrect request.")
                completion(.requestError)
            }
        }
    }
}
