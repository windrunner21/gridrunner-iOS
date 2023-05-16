//
//  Tile.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 12.05.23.
//

import UIKit

class Tile: UIButton {
    var type: TileType = .unknown
    
    private var identifier: String = String()
    var position: Coordinate
    
    private var hasBeenOpened: Bool = false
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.imageView?.tintColor = .white
    }
    
    override init(frame: CGRect) {
        self.position = Coordinate(x: 0, y: 0)
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        self.position = Coordinate(x: 0, y: 0)
        super.init(coder: coder)
    }
    
    func getIdentifier() -> String {
        self.identifier
    }
    
    func isOpen() -> Bool {
        self.hasBeenOpened
    }

    func setIdentifier(_ id: String) {
        self.identifier = id
    }
    
    func open() {
        self.hasBeenOpened = true
        self.backgroundColor = .systemIndigo.withAlphaComponent(0.5)
    }
    
    func updateDirectionImage(to: MoveDirection, from: MoveDirection? = nil, oldTile: Tile? = nil) {
        switch (from, to) {
        case (.up, .left):
            self.setDirectionImages(newDirection: .left, oldDirection: .upLeft, for: oldTile)
        case (.up, .right):
            self.setDirectionImages(newDirection: .right, oldDirection: .upRight, for: oldTile)
        case (.right, .up):
            self.setDirectionImages(newDirection: .up, oldDirection: .rightUp, for: oldTile)
        case (.right, .down):
            self.setDirectionImages(newDirection: .down, oldDirection: .rightDown, for: oldTile)
        case (.down, .right):
            self.setDirectionImages(newDirection: .right, oldDirection: .downRight, for: oldTile)
        case (.down, .left):
            self.setDirectionImages(newDirection: .left, oldDirection: .downLeft, for: oldTile)
        case (.left, .down):
            self.setDirectionImages(newDirection: .down, oldDirection: .leftDown, for: oldTile)
        case (.left, .up):
            self.setDirectionImages(newDirection: .up, oldDirection: .leftUp, for: oldTile)
        default:
            self.setDirectionImage(to: ArrowDirection(from: to))
        }
    }
    
    private func setDirectionImages(newDirection: ArrowDirection, oldDirection: ArrowDirection, for oldTile: Tile?) {
        oldTile?.setDirectionImage(to: oldDirection)
        self.setDirectionImage(to: newDirection)
    }
    
    private func setDirectionImage(to direction: ArrowDirection) {
        switch direction {
        case .up:
            self.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        case .right:
            self.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        case .down:
            self.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        case .left:
            self.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        case .upLeft:
            self.setImage(UIImage(systemName: "arrow.turn.up.left"), for: .normal)
        case .upRight:
            self.setImage(UIImage(systemName: "arrow.turn.up.right"), for: .normal)
        case .rightUp:
            self.setImage(UIImage(systemName: "arrow.turn.right.up"), for: .normal)
        case .rightDown:
            self.setImage(UIImage(systemName: "arrow.turn.right.down"), for: .normal)
        case .downRight:
            self.setImage(UIImage(systemName: "arrow.turn.down.right"), for: .normal)
        case .downLeft:
            self.setImage(UIImage(systemName: "arrow.turn.down.left"), for: .normal)
        case .leftDown:
            self.setImage(UIImage(systemName: "arrow.turn.left.down"), for: .normal)
        case .leftUp:
            self.setImage(UIImage(systemName: "arrow.turn.left.up"), for: .normal)
        case .unknown:
            break;
        }
    }
}
