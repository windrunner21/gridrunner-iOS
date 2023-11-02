//
//  Grid.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 02.11.23.
//

import Foundation

struct Grid: GridProtocol {
    var height: Int
    var width: Int    
    var tiles: [Tile]
    
    init() {
        self.height = Int()
        self.width = Int()
        self.tiles = []
    }
}

