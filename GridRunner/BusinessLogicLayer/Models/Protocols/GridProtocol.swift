//
//  GridProtocol.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 02.11.23.
//

protocol GridProtocol {
    var height: Int { get }
    var width: Int { get }
    var tiles: [Tile] { get }
}
