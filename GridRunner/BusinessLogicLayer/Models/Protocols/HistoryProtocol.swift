//
//  HistoryProtocol.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 02.11.23.
//

protocol HistoryProtocol {
    var runner: [Turn] { get }
    var seeker: [Turn] { get }
}
