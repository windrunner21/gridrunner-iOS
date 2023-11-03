//
//  RoomManager.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 03.11.23.
//

struct RoomManager {
    private let apiClient = APIClient(baseURL: .gameServer)
    private let gameService: GameService
    let alertAdapter: AlertAdapter
    
    init() {
        self.gameService = GameService(client: apiClient)
        self.alertAdapter = AlertAdapter()
    }
    
    func createRoom(as role: String, withId clientId: String, completion: @escaping(Response)->Void) {
        self.gameService.createRoom(as: role, withId: clientId, completion: completion)
    }
}
