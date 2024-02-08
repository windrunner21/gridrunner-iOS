//
//  GraphNode.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 15.11.23.
//

import Foundation

class GraphNode {
    var gameState: Game
    var children: [GraphNode] = []
    
    init(with gameState: Game) {
        self.gameState = gameState
    }
}
