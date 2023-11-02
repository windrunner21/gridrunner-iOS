//
//  GridModel.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 19.06.23.
//

import Foundation

struct OnlineGrid: AnyResponseParser, GridProtocol, Decodable {
    var height: Int
    var width: Int
    var tiles: [Tile] {
        specialTiles.map { $0.toTile() }
    }
    
    private var specialTiles: [SpecialTile]
}
