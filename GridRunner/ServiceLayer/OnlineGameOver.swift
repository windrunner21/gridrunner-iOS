//
//  OnlineGameOver.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 02.07.23.
//

struct OnlineGameOver: AnyResponseParser, GameOverProtocol, Decodable {
    var winner: PlayerType {
        switch self.SLWinner {
        case "runner":
            return .runner
        case "seeker":
            return .seeker
        default:
            return .server
        }
    }
    
    var type: String
    var reason: String?
    var history: HistoryProtocol
    private var SLWinner: String?
    
    enum CodingKeys: String, CodingKey {
        case type
        case reason
        case history = "turnHistory"
        case SLWinner = "winner"
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(String.self, forKey: .type)
        self.reason = try container.decodeIfPresent(String.self, forKey: .reason)
        self.history = try container.decode(OnlineHistory.self, forKey: .history)
        self.SLWinner = try container.decodeIfPresent(String.self, forKey: .SLWinner)
    }
}
