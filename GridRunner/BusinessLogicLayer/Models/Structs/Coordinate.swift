//
//  Coordinate.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 12.05.23.
//

struct Coordinate: Hashable, CustomStringConvertible {
    var x: Int
    var y: Int
    
    var description: String {
        return "(\(x), \(y))"
    }
}
