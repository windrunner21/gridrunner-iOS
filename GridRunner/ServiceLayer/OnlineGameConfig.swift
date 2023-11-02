//
//  GameConfig.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 19.06.23.
//

import Foundation

struct OnlineGameConfig: AnyResponseParser, Configurable, Decodable {
    var grid: GridProtocol
    var runner: String?
    var seeker: String?
    var opponent: String
    var runnerMovesLeft: Int
    var seekerMovesLeft: Int
    var turn: String
    var turnHistory: TurnHistory
    var type: String
    
    enum CodingKeys: String, CodingKey {
        case grid
        case runner
        case seeker
        case opponent
        case runnerMovesLeft
        case seekerMovesLeft
        case turn
        case turnHistory
        case type
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.grid = try container.decode(OnlineGrid.self, forKey: .grid)
        self.runner = try container.decodeIfPresent(String.self, forKey: .runner)
        self.seeker = try container.decodeIfPresent(String.self, forKey: .seeker)
        self.opponent = try container.decode(String.self, forKey: .opponent)
        self.runnerMovesLeft = try container.decode(Int.self, forKey: .runnerMovesLeft)
        self.seekerMovesLeft = try container.decode(Int.self, forKey: .seekerMovesLeft)
        self.turn = try container.decode(String.self, forKey: .turn)
        self.turnHistory = try container.decode(TurnHistory.self, forKey: .turnHistory)
        self.type = try container.decode(String.self, forKey: .type)
    }
}
