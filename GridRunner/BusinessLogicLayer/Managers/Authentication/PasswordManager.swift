//
//  PasswordManager.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 03.11.23.
//

struct PasswordManager {
    private let apiClient = APIClient(baseURL: .serverless)
    private let passwordService: PasswordService
    let alertAdapter: AlertAdapter
    
    init() {
        self.passwordService = PasswordService(client: self.apiClient)
        self.alertAdapter = AlertAdapter()
    }
    
    func resetUserPassword(for email: String, completion: @escaping(Response)->Void) {
        self.passwordService.resetPassword(for: email, completion: completion)
    }
}
