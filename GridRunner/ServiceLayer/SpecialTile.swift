//
//  SpecialTile.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 19.06.23.
//

import Foundation

class SpecialTile: ResponseParser, Decodable, CustomStringConvertible {
    private var type: String
    private var x: Int
    private var y: Int
    
    var description: String {
        "(Special Tile with coordinates at: \(x), \(y). Type: \(type))"
    }
    
    func toTile() -> Tile {
        let tile = Tile()
        tile.position = Coordinate(x: self.x, y: self.y)
        
        switch self.type {
        case "spawn":
            tile.type = .start
        case "exit":
            tile.type = .exit
        case "wall":
            tile.type = .closed
        case "empty":
            tile.type = .outer
        default:
            tile.type = .basic
        }
    
        return tile
    }
}
