//
//  Tile.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 12.05.23.
//

import UIKit

class Tile: UIButton {
    typealias OpenState = (byRunner: Bool, bySeeker: Bool)
    var type: TileType = .unknown
    
    private var identifier: String = String()
    var position: Coordinate
    
    private var openedByRunner: Bool = false
    private var openedBySeeker: Bool = false

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
    
    func hasBeenOpened() -> OpenState {
        (byRunner: self.openedByRunner, bySeeker: self.openedBySeeker)
    }
    
    func hasBeenOpenedBy(_ playerType: PlayerType) -> Bool {
        playerType == .runner ? self.openedByRunner : self.openedBySeeker
    }

    func setIdentifier(_ id: String) {
        self.identifier = id
    }
    
    func openByRunner(explicit: Bool) {
        self.openedByRunner = true
        if explicit {
            self.backgroundColor = .systemIndigo.withAlphaComponent(0.5)
        }
    }
    
    func openBySeeker(explicit: Bool) {
        self.openedBySeeker = true
        if explicit {
            self.backgroundColor = .systemYellow.withAlphaComponent(0.5)
        }
    }
    
    func closeBy(_ player: Player) {
        if player.type == .runner {
            self.openedByRunner = false
        } else {
            self.openedBySeeker = false
        }
        
        self.backgroundColor = .systemGray3
        self.setImage(nil, for: .normal)
    }
    
    func setupTile(at row: Int, and column: Int, with dimensions: MapDimensions, and history: History? = nil) {
        // Handle tile type and color
        if (row == 0 && column == 0) ||
            (row == dimensions.getNumberOfRows() - 1 &&
            column == dimensions.getNumberOfColumns() - 1)  {
            self.type = .exit
            self.decorateExit()
        } else if row == dimensions.getNumberOfRows() / 2 &&
                  column == dimensions.getNumberOfColumns() / 2 {
            self.type = .start
            self.decorateSpawn()
        } else {
            self.type = .basic
            self.backgroundColor = .systemGray3
        }
        
        // Handle tile with history
//        if let gameHistory = gameHistory {
//            let tilePosition = Coordinate(x: row, y: column)
//            if gameHistory.getRunnerHistory().contains(tilePosition) {
//                self.openByRunner(explicit: false)
//            }
//
//            if gameHistory.getSeekerHistory().contains(tilePosition) {
//                self.openBySeeker(explicit: true)
//            }
//        }
    }
    
    /// Updates old and current Tile's direction image for Runner.
    func updateDirectionImage(to currentDirection: MoveDirection, from oldDirection: MoveDirection? = nil, oldTile: Tile? = nil) {
        switch (oldDirection, currentDirection) {
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
            self.setDirectionImages(newDirection: ArrowDirection(from: currentDirection), oldDirection: ArrowDirection(from: currentDirection), for: oldTile)
        }
    }
    
    /// Updates current and new Tile's direction image for Seeker.
    func updateDirectionImage(from currentDirection: MoveDirection, oldTile: Tile? = nil, to newDirection: MoveDirection? = nil, newTile: Tile? = nil) {
        if let oldX = oldTile?.position.x, let newX = newTile?.position.x,
           let oldY = oldTile?.position.y, let newY = newTile?.position.y {
            switch (currentDirection, newDirection) {
            case (.up, .left) where oldX == newX:
                self.setDirectionImage(to: .upLeft)
            case (.up, .right) where oldX == newX:
                self.setDirectionImage(to: .upRight)
            case (.right, .up) where oldY == newY:
                self.setDirectionImage(to: .rightUp)
            case (.right, .down) where oldY == newY:
                self.setDirectionImage(to: .rightDown)
            case (.down, .right) where oldX == newX:
                self.setDirectionImage(to: .downRight)
            case (.down, .left) where oldX == newX:
                self.setDirectionImage(to: .downLeft)
            case (.left, .down) where oldY == newY:
                self.setDirectionImage(to: .leftDown)
            case (.left, .up) where oldY == newY:
                self.setDirectionImage(to: .leftUp)
            default:
                self.setDirectionImage(to: ArrowDirection(from: currentDirection))
            }
        } else {
            self.setDirectionImage(to: ArrowDirection(from: currentDirection))
        }
    }
    
    func decorateExit() {
        self.backgroundColor = .systemMint
        self.setImage(UIImage(systemName: "flag.checkered"), for: .normal)
    }
    
    func decorateSpawn() {
        self.backgroundColor = .systemIndigo
        self.setImage(UIImage(systemName: "house.fill"), for: .normal)
    }
    
    func decorateRunner() {
        self.backgroundColor = .systemIndigo
        self.setImage(UIImage(systemName: "face.smiling.fill"), for: .normal)
    }
    
    func decorateRunnerWin() {
        self.backgroundColor = .systemGreen
        self.setImage(UIImage(systemName: "flag.checkered.2.crossed"), for: .normal)
    }
    
    func decorateSeekerWin() {
        self.backgroundColor = .systemGreen
        self.setImage(UIImage(systemName: "figure.walk"), for: .normal)
    }
    
    private func setDirectionImages(newDirection: ArrowDirection, oldDirection: ArrowDirection, for oldTile: Tile?) {
        self.decorateRunner()
        
        guard oldTile?.type != .start else { return }
        oldTile?.setDirectionImage(to: oldDirection)
        oldTile?.backgroundColor = .systemIndigo.withAlphaComponent(0.5)
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
