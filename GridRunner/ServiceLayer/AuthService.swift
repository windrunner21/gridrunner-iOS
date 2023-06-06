//
//  AuthService.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 05.06.23.
//

import Foundation

class AuthService {
    let client = APIClient(baseURL: .serverless)
    let loginURL = URL(string: BaseURL.serverless.rawValue + URLPath.login.rawValue)!
    
    func login(with credentials: LoginCredentials, completion: @escaping(Data?, Error?) -> Void) {
        
        client.sendRequest(
            path: URLPath.login.rawValue,
            method: .POST,
            parameters: credentials.encode()
        ) { data, response, error in
            
            if let error = error {
                print("in error")
                completion(nil, error)
            } else if let data = data {
                print("in data")
                if let responseDataString = String(data: data, encoding: .utf8) {
                    print(responseDataString)
                }
                
                if let response = response as? HTTPURLResponse {
                    
                    if response.statusCode != 200 {
                        completion(nil, error)
                        return
                    }
                    
                    if let headers = response.allHeaderFields as? [String: String] {
                        let cookies = HTTPCookie.cookies(withResponseHeaderFields: headers, for: self.loginURL)
                        for cookie in cookies {
                            print("Cookie: \(cookie.name) = \(cookie.value)")
                        }
                    }
                    
                    completion(data, nil)
                }
            }
        }
    }
    
    func register(with credentials: RegisterCredentials) {
        client.sendRequest(path: "/signup", method: .POST, parameters: credentials.encode()) { data, response, error in
            if let error = error {
                print(error)
            } else if let data = data {
                if let responseDataString = String(data: data, encoding: .utf8) {
                    print(responseDataString)
                }
            }
        }
    }
}
