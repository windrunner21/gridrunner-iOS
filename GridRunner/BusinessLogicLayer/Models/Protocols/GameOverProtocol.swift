//
//  GameOverProtocol.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 02.11.23.
//

protocol GameOverProtocol {
    var winner: PlayerType { get }
    var type: String { get }
    var reason: String? { get }
    var history: HistoryProtocol { get }
}
