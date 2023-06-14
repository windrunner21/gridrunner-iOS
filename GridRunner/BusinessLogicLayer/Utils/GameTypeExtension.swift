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
            return "Quick Play"
        case .rankedplay:
            return "Competitive Play"
        case .roomplay:
            return "Friendly Play"
        }
    }
}
