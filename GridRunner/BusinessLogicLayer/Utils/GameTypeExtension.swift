//
//  GameTypeExtension.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 14.06.23.
//

extension GameType {
    var label: String {
        switch self {
        case .quickplay:
            return "Unranked"
        case .rankedplay:
            return "Competitive"
        case .roomplay:
            return "Friendly"
        }
    }
}
