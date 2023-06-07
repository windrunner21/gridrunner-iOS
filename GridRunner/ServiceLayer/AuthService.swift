//
//  AuthService.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 05.06.23.
//

import Foundation

class AuthService {
    let client = APIClient(baseURL: .serverless)
    let loginURL = URL(string: BaseURL.serverless.url + URLPath.login.path)!
    let registerURL = URL(string: BaseURL.serverless.url + URLPath.register.path)!
    
    func login(with credentials: LoginCredentials, completion: @escaping(Bool) -> Void) {
        client.sendRequest(
            path: URLPath.login.path,
            method: .POST,
            parameters: credentials.encode()
        ) { data, response, error in
            
            if let error = error {
                NSLog("Error occured: \(error)")
                completion(false)
            } else if let data = data {
                if let responseDataString = String(data: data, encoding: .utf8) {
                    print(responseDataString)
                }
                
                if let response = response as? HTTPURLResponse {
                    
                    if response.statusCode != 200 {
                        completion(false)
                        return
                    }
                    
                    if let headers = response.allHeaderFields as? [String: String] {
                        let cookies = HTTPCookie.cookies(withResponseHeaderFields: headers, for: self.loginURL)
                        for cookie in cookies {
                            print("Cookie from login: \(cookie.name) = \(cookie.value)")
                        }
                    }
                    
                    completion(true)
                }
            }
        }
    }
    
    func register(with credentials: RegisterCredentials, completion: @escaping(Bool) -> Void) {
        client.sendRequest(
            path: URLPath.register.path,
            method: .POST,
            parameters: credentials.encode()
        ) { data, response, error in
            
            if let error = error {
                NSLog("Error occured: \(error)")
                completion(false)
            } else if let data = data {
                if let responseDataString = String(data: data, encoding: .utf8) {
                    print(responseDataString)
                }
                
                if let response = response as? HTTPURLResponse {
                    if response.statusCode != 200 {
                        completion(false)
                        return
                    }
                    
                    if let headers = response.allHeaderFields as? [String: String] {
                        let cookies = HTTPCookie.cookies(withResponseHeaderFields: headers, for: self.registerURL)
                        
                        for cookie in cookies {
                            print("Cookie from register: \(cookie.name) = \(cookie.value)")
                        }
                    }
                }
                
                completion(true)
            }
        }
    }
}
