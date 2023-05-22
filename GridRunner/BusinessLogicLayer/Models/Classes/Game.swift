//
//  Game.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 12.05.23.
//

class Game {
    private var map: Map
    private var player: Player?
    private var history: History
    
    convenience init() {
        self.init(map: Map())
    }
    
    init(map: Map, player: Player? = nil, history: History? = nil) {
        self.map = map
        self.player = player
        self.history = history ?? History()
    }
    
    func getMap() -> Map {
        self.map
    }
    
    func getPlayer() -> Player? {
        self.player
    }
    
    func getHistory() -> History {
        self.history
    }
    
    func createSession(with map: Map, for player: Player, with history: History? = nil) {
        self.map = map
        self.player = player
        self.history = history ?? History()
    }
}
