//
//  Game.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 12.05.23.
//

class Game {
    private var map: Map
    private var player: AnyPlayer?
    private var history: History
    
    convenience init() {
        self.init(map: Map())
    }
    
    init(map: Map, player: AnyPlayer? = nil, history: History? = nil) {
        self.map = map
        self.player = player
        self.history = history ?? History()
    }
    
    func getMap() -> Map {
        self.map
    }
    
    func getPlayer() -> AnyPlayer? {
        self.player
    }
    
    func getHistory() -> History {
        self.history
    }
    
    func createSession(with map: Map, for player: AnyPlayer, with history: History? = nil) {
        self.map = map
        self.player = player
        self.history = history ?? History()
    }
}
