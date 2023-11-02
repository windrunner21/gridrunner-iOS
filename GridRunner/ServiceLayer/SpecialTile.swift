//
//  SpecialTile.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 19.06.23.
//

import Foundation

struct SpecialTile: AnyResponseParser, Decodable {
    private var type: String
    private var x: Int
    private var y: Int
    
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
