//
//  Configurable.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 27.10.23.
//

protocol Configurable {
    var grid: GridProtocol { get }
    var runner: String? { get }
    var seeker: String? { get }
    var opponent: String { get }
    var runnerMovesLeft: Int { get }
    var seekerMovesLeft: Int { get }
    var turn: String { get }
    var history: HistoryProtocol { get }
    var type: String { get }
}
