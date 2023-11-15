//
//  GameNode.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 15.11.23.
//

import Foundation

class GameTreeNode {
    var game: Game
    var children: [GameTreeNode] = []
    
    init(with game: Game) {
        self.game = game
    }
}

class GameGraphNode {
    var game: Game
    var children: [GameTreeNode] = []
    
    init(with game: Game) {
        self.game = game
    }
}
