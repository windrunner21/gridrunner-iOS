//
//  LoginManager.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 03.11.23.
//

struct LoginManager {
    private let apiClient = APIClient(baseURL: .serverless)
    private let authService: AuthService
    let alertAdapter: AlertAdapter
    
    init() {
        self.authService = AuthService(client: self.apiClient)
        self.alertAdapter = AlertAdapter()
    }
    
    func loginUser(with credentials: LoginCredentials, completion: @escaping(Response)->Void) {
        self.authService.login(with: credentials, completion: completion)
    }
}
