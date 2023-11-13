//
//  AuthService.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 05.06.23.
//

import Foundation

struct AuthService {
    private let client: ApiClientProtocol
    private let loginURL = URL(string: BaseURL.serverless.url + URLPath.login.path)!
    private let registerURL = URL(string: BaseURL.serverless.url + URLPath.register.path)!
    
    init(client: ApiClientProtocol) {
        self.client = client
    }
    
    func login(with credentials: LoginCredentials, completion: @escaping(Response) -> Void) {
        self.client.sendRequestWithBody(path: URLPath.login.path, method: .POST, body: credentials.encode()) {
            data, response, error in
            
            if let error = error {
                Log.error("Error occured in AuthService().login(): \(error)")
                completion(.networkError)
            } else if let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data {
                let user = User.decode(data: data, type: User.self)
                
                if let user = user {
                    User.shared.update(with: user)
                    self.client.getCookie(from: response, from: self.loginURL)
                    completion(.success)
                } else {
                    Log.error("Error occured in AuthService().login(): Cannot decode JSON to User class.")
                    completion(.decoderError)
                }
            } else {
                Log.error("Error occured in AuthService().login(): Incorrect request.")
                completion(.requestError)
            }
        }
    }
    
    func register(with credentials: RegisterCredentials, completion: @escaping(Response) -> Void) {
        self.client.sendRequestWithBody(path: URLPath.register.path, method: .POST, body: credentials.encode()) {
            data, response, error in
            
            if let error = error {
                Log.error("Error occured in AuthService().register(): \(error)")
                completion(.networkError)
            } else if let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data {
                let user = User.decode(data: data, type: User.self)
                
                if let user = user {
                    User.shared.update(with: user)
                    self.client.getCookie(from: response, from: self.registerURL)
                    completion(.success)
                } else {
                    Log.error("Error occured in AuthService().register(): Cannot decode JSON to User class.")
                    completion(.decoderError)
                }
            } else {
                Log.error("Error occured in AuthService().register(): Incorrect request.")
                completion(.requestError)
            }
        }
    }
    
    func logout(completion: @escaping(Response) -> Void) {
        self.client.sendRequest(path: URLPath.logout.path, method: .POST) { 
            data, response, error in
            
            if let error = error {
                Log.error("Error occured in AuthService().logout(): \(error)")
                completion(.networkError)
            } else if let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data {
                let user = User.decode(data: data, type: User.self)
                
                if let user = user {
                    User.shared.update(with: user)
                    self.client.removeCookie()
                    completion(.success)
                } else {
                    Log.error("Error occured in AuthService().logout(): Cannot decode JSON to User class.")
                    completion(.decoderError)
                }
            } else {
                Log.error("Error occured in AuthService().logout(): Incorrect request.")
                completion(.requestError)
            }
        }
    }
    
    func deleteAccount(completion: @escaping(Response) -> Void) {
        let cookies = (name: "gridrun-session", value: UserDefaults.standard.value(forKey: "session") as? String)
        
        self.client.sendRequestWithCookies(path: URLPath.delete.path, method: .POST, cookies: cookies) {
            data, response, error in
            
            if let error = error {
                Log.error("Error occured in AuthService().deleteAccount(): \(error)")
                completion(.networkError)
            } else if let response = response as? HTTPURLResponse, response.statusCode == 200, let data = data {
                let user = User.decode(data: data, type: User.self)
                
                if let user = user {
                    User.shared.update(with: user)
                    self.client.removeCookie()
                    completion(.success)
                } else {
                    Log.error("Error occured in AuthService().deleteAccount(): Cannot decode JSON to User class.")
                    completion(.decoderError)
                }
            } else {
                Log.error("Error occured in AuthService().deleteAccount(): Incorrect request.")
                completion(.requestError)
            }
        }
    }
}
