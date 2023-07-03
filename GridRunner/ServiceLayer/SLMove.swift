//
//  Move.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 01.07.23.
//

import Foundation

class SLMove: ResponseParser, Decodable {
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

private class SLRunnerCoordinate: ResponseParser, Decodable {
    private var x: Int
    private var y: Int
    
    func getCoordinate() -> Coordinate {
        Coordinate(x: self.x, y: self.y)
    }
}

// TODO: from here
// show if im seeker
//moves =     (
//            {
//        from =             {
//            x = 7;
//            y = 7;
//        };
//        to =             {
//            x = 8;
//            y = 7;
//        };
//        type = moveTo;
//    },
//            {
//        from =             {
//            x = 8;
//            y = 7;
//        };
//        to =             {
//            x = 9;
//            y = 7;
//        };
//        type = moveTo;
//    }
//);

// show if im runner
//moves =     (
//            {
//        type = openTile;
//        x = 8;
//        y = 6;
//    }
//);
