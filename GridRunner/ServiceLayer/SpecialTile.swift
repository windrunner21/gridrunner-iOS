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
    
    private override init() {
        self.type = String()
        self.x = Int()
        self.y = Int()
    }
    
    private init(type: String, x: Int, y: Int) {
        self.type = type
        self.x = x
        self.y = y
    }
    
    func update(with tile: SpecialTile) {
        self.type = tile.type
        self.x = tile.x
        self.y = tile.y
    }
}
