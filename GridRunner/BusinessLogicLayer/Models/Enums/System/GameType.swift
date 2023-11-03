//
//  GameType.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 14.06.23.
//

enum GameType {
    case quickplay
    case rankedplay
    case roomplay
}

extension GameType {
    var channelName: String {
        switch self {
        case .quickplay:
            return "quick-play-queue"
        case .rankedplay:
            return "ranked-play-queue"
        case .roomplay:
            return "quick-play-queue"
        }
    }
}
