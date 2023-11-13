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
    
    mutating func setupGrid(as type: MapType) throws {
        self._setDimensions(13, by: 13)
        switch type {
        case .basic:
            self._setBasic()
        case .bordered:
            self._setBordered()
        case .shaped:
            self._setShaped()
        case .unknown:
            throw GameError.unknownMapType
        }
    }
    
    private mutating func _setDimensions(_ height: Int, by width: Int) {
        self.height = height
        self.width = width
    }
    
    private mutating func _setBasic() {
        self.tiles.append(contentsOf: [
            self._generateTile(at: 5, and: 5, as: .start),
            self._generateTile(at: 0, and: 0, as: .exit),
            self._generateTile(at: 12, and: 0, as: .exit),
            self._generateTile(at: 0, and: 12, as: .exit),
            self._generateTile(at: 12, and: 12, as: .exit),
        ])
    }
    
    private mutating func _setBordered() {
        self.tiles.append(contentsOf: [
            self._generateTile(at: 5, and: 5, as: .start),
            self._generateTile(at: 0, and: 0, as: .exit),
            self._generateTile(at: 12, and: 12, as: .exit),
            self._generateTile(at: 0, and: 1, as: .closed),
            self._generateTile(at: 1, and: 1, as: .closed),
            self._generateTile(at: 2, and: 1, as: .closed),
            self._generateTile(at: 3, and: 1, as: .closed),
            self._generateTile(at: 4, and: 1, as: .closed),
            self._generateTile(at: 7, and: 6, as: .closed),
            self._generateTile(at: 7, and: 6, as: .closed),
            self._generateTile(at: 9, and: 6, as: .closed),
            self._generateTile(at: 10, and: 6, as: .closed),
            self._generateTile(at: 7, and: 7, as: .closed),
            self._generateTile(at: 7, and: 8, as: .closed),
            self._generateTile(at: 7, and: 10, as: .closed)
        ])
    }
    
    private mutating func _setShaped() {
        self.tiles.append(contentsOf: [
            self._generateTile(at: 5, and: 5, as: .start),
            self._generateTile(at: 12, and: 0, as: .exit),
            self._generateTile(at: 0, and: 12, as: .exit),
            self._generateTile(at: 0, and: 2, as: .outer),
            self._generateTile(at: 0, and: 3, as: .outer),
            self._generateTile(at: 0, and: 4, as: .outer),
            self._generateTile(at: 0, and: 5, as: .outer),
            self._generateTile(at: 1, and: 0, as: .outer),
            self._generateTile(at: 2, and: 0, as: .outer),
            self._generateTile(at: 3, and: 0, as: .outer),
            self._generateTile(at: 4, and: 0, as: .outer),
            self._generateTile(at: 5, and: 0, as: .outer)
        ])
    }
    
    private func _generateTile(at x: Int, and y: Int, as type: TileType) -> Tile {
        let tile = Tile()
        tile.position = Coordinate(x: x, y: y)
        tile.type = type
        return tile
    }
}

