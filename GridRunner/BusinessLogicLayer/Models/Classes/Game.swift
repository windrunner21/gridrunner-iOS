//
//  Game.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 12.05.23.
//

class Game {
    private var map: Map
    private var player: Player?
    
    convenience init() {
        self.init(map: Map())
    }
    
    init(map: Map, player: Player? = nil) {
        self.map = map
        self.player = player
    }
    
    func getMap() -> Map {
        map
    }
    
    func getPlayer() -> Player? {
        player
    }
    
    func createSession(with map: Map, for player: Player) {
        self.map = map
        self.player = player
    }
}
