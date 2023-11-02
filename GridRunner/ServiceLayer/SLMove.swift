//
//  Move.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 01.07.23.
//

import Foundation

class SLMove: AnyResponseParser, Decodable {
    private var type: String
    private var from: SLRunnerCoordinate?
    private var to: SLRunnerCoordinate?
    private var x: Int?
    private var y: Int?
    
    func getRunnerMove() -> Move? {
        guard let from = self.from, let to = self.to else { return nil }
        
        return Move(from: from.getCoordinate(), to: to.getCoordinate())
    }
    
    func getCoordinate() -> Coordinate? {
        guard let x = self.x, let y = self.y else { return nil }
        
        return Coordinate(x: x, y: y)
    }
    
    func getMoveType() -> MoveType {
        switch self.type {
        case "openTile":
            return .seeker
        case "moveTo":
            return .runner
        default:
            return .unknown
        }
    }
}

private class SLRunnerCoordinate: AnyResponseParser, Decodable {
    private var x: Int
    private var y: Int
    
    func getCoordinate() -> Coordinate {
        Coordinate(x: self.x, y: self.y)
    }
}
