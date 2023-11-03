//
//  ProfileManager.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 03.11.23.
//

import Foundation

struct ProfileManager {
    private let apiClient = APIClient(baseURL: .serverless)
    private let authService: AuthService
    let alertAdapter: AlertAdapter
    
    init() {
        self.authService = AuthService(client: self.apiClient)
        self.alertAdapter = AlertAdapter()
    }
    
    func logoutFromAccount(completion: @escaping(Response)->Void) {
        self.authService.logout(completion: completion)
    }
    
    func deleteAccount(completion: @escaping(Response)->Void) {
        self.authService.deleteAccount(completion: completion)
    }
}
