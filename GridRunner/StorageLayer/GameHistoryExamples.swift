//
//  GameHistoryExamples.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 18.05.23.
//

struct GameHistoryExamples {
    var runnerHistory1: [Turn] = []
    
    var runnerHistory2: [Turn] = [
        Turn(moves: [
            Move(from: Coordinate(x: 6, y: 6), to: Coordinate(x: 6, y: 5)),
            Move(from: Coordinate(x: 6, y: 5), to: Coordinate(x: 6, y: 4))
        ]),
        Turn(moves: [
            Move(from: Coordinate(x: 6, y: 4), to: Coordinate(x: 6, y: 3))
        ])
    ]
    
    var seekerHistory1: [Turn] = []
    
    var seekerHistory2: [Turn] = [
        Turn(moves: [
            Move(from: Coordinate(x: 6, y: 6), to: Coordinate(x: 6, y: 5))
        ]),
        Turn(moves: [
            Move(from: Coordinate(x: 6, y: 5), to: Coordinate(x: 5, y: 5))
        ])
    ]
}
