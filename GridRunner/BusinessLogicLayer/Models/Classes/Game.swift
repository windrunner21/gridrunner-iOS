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
    
    func identifyRunnerMovingDirection(from oldPosition: Coordinate, to newPosition: Coordinate) -> MoveDirection {
        // horizontal movement
        // left
        if oldPosition.x == newPosition.x && oldPosition.y > newPosition.y {
            return .left
        }
        // right
        if oldPosition.x == newPosition.x && oldPosition.y < newPosition.y {
            return .right
        }
        
        // vertical movement
        // up
        if oldPosition.x > newPosition.x && oldPosition.y == newPosition.y {
            return .up
        }
        // down
        if oldPosition.x < newPosition.x && oldPosition.y == newPosition.y {
            return .down
        }
        
        return .unknown
    }
}
