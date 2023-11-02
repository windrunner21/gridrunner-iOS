//
//  OfflineGameConfig.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 02.11.23.
//

import Foundation

struct OfflineGameConfig: Configurable {
    var grid: Grid
    var runner: String?
    var seeker: String?
    var opponent: String
    var runnerMovesLeft: Int
    var seekerMovesLeft: Int
    var turn: String
    var turnHistory: TurnHistory
    var type: String
}
