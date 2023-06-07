//
//  ArrowDirection.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 16.05.23.
//

enum ArrowDirection {
    case upLeft
    case up
    case upRight
    
    case rightUp
    case right
    case rightDown
    
    case downRight
    case down
    case downLeft
    
    case leftDown
    case left
    case leftUp
    
    case unknown
}

extension ArrowDirection {
    init(from moveDirection: MoveDirection) {
        switch moveDirection {
        case .up:
            self = .up
        case .right:
            self = .right
        case .down:
            self = .down
        case .left:
            self = .left
        case.unknown:
            self = .unknown
        }
    }
}
