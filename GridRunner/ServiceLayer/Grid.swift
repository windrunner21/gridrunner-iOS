//
//  Grid.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 19.06.23.
//

import Foundation

class Grid: ResponseParser, Decodable, CustomStringConvertible {
    
    var height: Int
    var width: Int
    var specialTiles: [SpecialTile]
    
    var description: String {
        "Grid is initialized with following dimensions: \(height)x\(width). Special tiles are: \(specialTiles)"
    }
    
    override init() {
        self.height = Int()
        self.width = Int()
        self.specialTiles = []
    }
    
    private init(height: Int, width: Int, specialTiles: [SpecialTile]) {
        self.height = height
        self.width = width
        self.specialTiles = specialTiles
    }
    
    func update(with grid: Grid) {
        self.height = grid.height
        self.width = grid.width
        self.specialTiles = grid.specialTiles
    }
}
