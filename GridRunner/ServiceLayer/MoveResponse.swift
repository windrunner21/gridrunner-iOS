//
//  MoveResponse.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 01.07.23.
//

import Foundation

class MoveResponse: AnyResponseParser, Decodable {
    static let shared = MoveResponse()
    
    private var moves: [SLMove]?
    private var playedBy: String
    
    private init() {
        self.moves = nil
        self.playedBy = String()
    }
    
    private init(playedBy: String, moves: [SLMove]?) {
        self.playedBy = playedBy
        self.moves = moves
    }
    
    func update(with response: MoveResponse) {
        self.moves = response.moves
        self.playedBy = response.playedBy
    }
    
    func getNextTurn() -> PlayerType {
        self.playedBy == "runner" ? .seeker : .runner
    }
    
    func getPlayedBy() -> PlayerType {
        switch self.playedBy {
        case "runner":
            return .runner
        case "seeker":
            return .seeker
        case "server":
            return .server
        default:
            return .server
        }
    }
    
    func getSeekerCoordinates() -> [Coordinate]? {
        guard let moves = self.moves else { return nil }
        
        var coordinates: [Coordinate] = []
        
        for move in moves {
            if move.getMoveType() == .seeker {
                guard let seekerToCoordinate = move.getCoordinate() else { return nil }
                coordinates.append(seekerToCoordinate)
            }
        }
        
        return coordinates
    }
    
    func getRunnerTurn() -> Turn?  {
        guard let moves = self.moves else { return nil }
        
        var movesInTurn: [Move] = []
        
        for move in moves {
            if move.getMoveType() == .runner {
                guard let runnerMove = move.getRunnerMove() else { return nil }
                movesInTurn.append(runnerMove)
            }
        }
        
        return Turn(moves: movesInTurn)
    }
}
