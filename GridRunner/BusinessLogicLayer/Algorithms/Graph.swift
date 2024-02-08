//
//  Graph.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 16.11.23.
//

import Foundation

class Graph {
    var root: GraphNode
    
    init(with game: Game) {
        self.root = GraphNode(with: game)
    }
    
    func buildGameGraph() {
        
    }
}
