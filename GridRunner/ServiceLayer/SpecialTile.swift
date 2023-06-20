//
//  SpecialTile.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 19.06.23.
//

import Foundation

class SpecialTile: ResponseParser, Decodable, CustomStringConvertible {
    var type: String
    var x: Int
    var y: Int
    
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
        default:
            tile.type = .basic
        }
    
        return tile
    }
}
