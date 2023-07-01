//
//  Move.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 01.07.23.
//

import Foundation

class SLMove: ResponseParser, Decodable {
    private var type: String
    private var x: Int
    private var y: Int
    
    func getCoordinate() -> Coordinate {
        Coordinate(x: self.x, y: self.y)
    }
}
