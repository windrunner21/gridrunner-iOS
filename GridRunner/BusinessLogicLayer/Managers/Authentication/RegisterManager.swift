//
//  RegisterManager.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 03.11.23.
//

struct RegisterManager {
    private let apiClient = APIClient(baseURL: .serverless)
    private let authService: AuthService
    let alertAdapter: AlertAdapter
    
    init() {
        self.authService = AuthService(client: self.apiClient)
        self.alertAdapter = AlertAdapter()
    }
    
    func registerUser(with credentials: RegisterCredentials, completion: @escaping(Response)->Void) {
        self.authService.register(with: credentials, completion: completion)
    }
}
