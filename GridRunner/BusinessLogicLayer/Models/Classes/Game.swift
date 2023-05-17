//
//  Game.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 12.05.23.
//

class Game {
    private var map: Map
    private var player: Player?
    private var gameHistory: GameHistory?
    
    convenience init() {
        self.init(map: Map())
    }
    
    init(map: Map, player: Player? = nil, gameHistory: GameHistory? = nil) {
        self.map = map
        self.player = player
        self.gameHistory = gameHistory
    }
    
    func getHistory() -> GameHistory? {
        self.gameHistory
    }
    
    func getMap() -> Map {
        self.map
    }
    
    func getPlayer() -> Player? {
        self.player
    }
    
    func createSession(with map: Map, for player: Player, with gameHistory: GameHistory? = nil) {
        self.map = map
        self.player = player
        self.gameHistory = gameHistory
    }
}
