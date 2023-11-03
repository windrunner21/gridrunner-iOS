//
//  AblyManager.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 03.11.23.
//

struct AblyManager {
    private let apiClient = APIClient(baseURL: .gameServer)
    private let JWTService: AblyJWTService
    
    init() {
        self.JWTService = AblyJWTService(client: self.apiClient)
    }
    
    func retrieveToken(completion: @escaping(Response, String?)->Void) {
        JWTService.getJWT(completion: completion)
    }
}
