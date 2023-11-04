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
                
        switch self.player?.type {
        case .runner:
            self.player?.setHistory(to: self.history.getRunnerHistory())
            self.player?.updateCurrentTurn(to: self.history.getRunnerHistory().count + 1)
        case .seeker:
            self.player?.setHistory(to: self.history.getSeekerHistory())
            self.player?.updateCurrentTurn(to: self.history.getSeekerHistory().count + 1)
        default:
            break
        }
        
        NSLog("Game session has been instantiated.")
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
                var move: Move
                if let lastToCoordinate = self.getHistory().getSeekerHistory().last?.getMoves().last?.to {
                    move = Move(from: lastToCoordinate, to: coordinate)
                } else {
                    // Set from coordinate as map center if previous move was empty by the Seeker.
                    move = Move(from: self.getMap().getCenterCoordinates(), to: coordinate)
                }
             
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
        guard let serverTurn = MoveResponse.shared.getRunnerTurn(), let firstMove = serverTurn.getMoves().first else { return }
        
        // Get only first move, as server turn always has 2 Moves for 1 Tile.
        let turn: Turn = Turn(moves: [firstMove])
        // Set runner history.
        self.getHistory().appendRunnerHistory(with: turn)
    }
}
