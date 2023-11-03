//
//  LaunchManager.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 03.11.23.
//

struct LaunchManager {
    private let apiClient = APIClient(baseURL: .serverless)
    private let userService: UserService
    let alertAdapter: AlertAdapter
    let forceUpgrade: Bool
    
    init() {
        self.userService = UserService(client: self.apiClient)
        self.alertAdapter = AlertAdapter()
        self.forceUpgrade = false
    }
    
    func retrieveLoggedInUser(completion: @escaping(Response)->Void) {
        self.userService.getUser(completion: completion)
    }
}
