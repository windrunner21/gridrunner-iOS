//
//  Game.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 12.05.23.
//

import Foundation

class Game {
    private var map: Map
    private var player: AnyPlayer?
    private var history: History
    
    convenience init() {
        self.init(map: Map())
    }
    
    init(map: Map, player: AnyPlayer? = nil, history: History? = nil) {
        self.map = map
        self.player = player
        self.history = history ?? History()
    }
    
    func getMap() -> Map {
        self.map
    }
    
    func getPlayer() -> AnyPlayer? {
        self.player
    }
    
    func getHistory() -> History {
        self.history
    }
    
    func createSession(with map: Map, for player: AnyPlayer, with history: History? = nil) {
        self.map = map
        self.player = player
        self.history = history ?? History()
        
        NSLog("Game has been instantiated.")
    }
    
    func updateSeekerHistory() {
        // Get coordinates seeker has traveled to.
        guard let coordinates = MoveResponse.shared.getSeekerCoordinates() else { return }
 
        var moves: [Move] = []
        
        // Create moves using these coordinates.
        for coordinate in coordinates {
            // If seeker history is empty, use initial move from as map center.
            if self.getHistory().getSeekerHistory().isEmpty {
                let move = Move(from: self.getMap().getCenterCoordinates(), to: coordinate)
                moves.append(move)
            } else {
                guard let lastToCoordinate = self.getHistory().getSeekerHistory().last?.getMoves().last?.to else {
                    return
                }
                
                let move = Move(from: lastToCoordinate, to: coordinate)
                
                moves.append(move)
            }
        }
        
        // Create turn from moves with coordinates.
        let turn = Turn(moves: moves)
        
        // Set seeker history.
        self.getHistory().appendSeekerHistory(with: turn)
    }
    
    func updateRunnerHistory() {
        // Get turn runner has completed on random.
        guard let turn = MoveResponse.shared.getRunnerTurn() else { return }
        // Set runner history.
        self.getHistory().appendRunnerHistory(with: turn)
    }
}
