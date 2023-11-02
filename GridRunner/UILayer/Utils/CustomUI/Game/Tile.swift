//
//  Tile.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 12.05.23.
//

import UIKit

class Tile: UIView {
    typealias OpenState = (byRunner: Bool, bySeeker: Bool)
    var type: TileType = .unknown
    var position: Coordinate
    
    private var identifier: String = String()
    private var imageView: UIImageView
    private var previousImageView: UIImageView?
    
    private var openedByRunner: Bool = false
    private var openedBySeeker: Bool = false

    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.setupImageView()
    }
    
    override init(frame: CGRect) {
        self.position = Coordinate(x: 0, y: 0)
        self.imageView = UIImageView()
        self.previousImageView = nil
        
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        self.position = Coordinate(x: 0, y: 0)
        self.imageView = UIImageView()
        self.previousImageView = nil
        
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
    
    func openByRunner(explicit: Bool, lastTurn: Turn?, oldTile: Tile?, and direction: MoveDirection ) {
        if self.openedByRunner {
            self.previousImageView = UIImageView(image: self.imageView.image)
        }
        
        self.openedByRunner = true
        if explicit {
            self.backgroundColor = UIColor(named: "Red")?.withAlphaComponent(0.5)
            self.updateDirectionImage(
                to: direction,
                from: lastTurn?.getMoves().last?.identifyMoveDirection(),
                oldTile: oldTile
            )
        }
    }
    
    func openBySeeker(explicit: Bool) {
        if self.openedByRunner || self.openedBySeeker {
            self.previousImageView = UIImageView(image: self.imageView.image)
        }
        
        self.openedBySeeker = true
        if explicit {
            self.backgroundColor = UIColor(named: "Black")?.withAlphaComponent(0.5)
        }
    }
    
    func closeBy(_ player: AnyPlayer) {
        if player.type == .runner && self.previousImageView == nil {
            self.openedByRunner = false
        } else if player.type == .seeker && self.previousImageView == nil {
            self.openedBySeeker = false
            self.removeHighlight()
        }
        
        self.backgroundColor = self.previousImageView == nil ? UIColor(named: "Gray")?.withAlphaComponent(0.25) : UIColor(named: "Red")?.withAlphaComponent(0.5)
        
        self.imageView.image = self.previousImageView?.image
    }
    
    func setupTile(at row: Int, and column: Int, with dimensions: MapDimensions, and history: History) {
        // Handle tile type and color.
        for tile in GameConfig.shared.grid.tiles {
            switch tile.type {
            case .start where tile.position == self.position:
                self.type = .start
                self.decorateSpawn()
            case .exit where tile.position == self.position:
                self.type = .exit
                self.decorateExit()
            case .closed where tile.position == self.position:
                self.type = .closed
                self.decorateClosed()
            case .outer where tile.position == self.position:
                self.type = .outer
                self.decorateOuter()
            default:
                break
            }
        }
        
        // If not special tile assign basic type.
        if self.type == .unknown {
            self.type = .basic
            self.backgroundColor = UIColor(named: "Gray")?.withAlphaComponent(0.25)

        }
        
        if row == 0 && column == 0 {
            self.layer.cornerRadius = 10
            self.layer.maskedCorners = [.layerMinXMinYCorner]
        }
        
        if row == 0 && column == dimensions.getNumberOfColumns() - 1 {
            self.layer.cornerRadius = 10
            self.layer.maskedCorners = [.layerMaxXMinYCorner]
        }
        
        
        if row == dimensions.getNumberOfRows() - 1 && column == 0 {
            self.layer.cornerRadius = 10
            self.layer.maskedCorners = [.layerMinXMaxYCorner]
        }
        
        
        if row == dimensions.getNumberOfRows() - 1 && column == dimensions.getNumberOfColumns() - 1 {
            self.layer.cornerRadius = 10
            self.layer.maskedCorners = [.layerMaxXMaxYCorner]
        }
    }
    
    /// Updates old and current Tile's direction image for Runner.
    private func updateDirectionImage(to currentDirection: MoveDirection, from oldDirection: MoveDirection? = nil, oldTile: Tile? = nil) {
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
            self.setDirectionImages(
                newDirection: ArrowDirection(from: currentDirection),
                oldDirection: ArrowDirection(from: currentDirection),
                for: oldTile
            )
        }
    }
    
    /// Updates current and new Tile's direction image for Seeker.
    private func updateDirectionImage(from currentDirection: MoveDirection, oldTile: Tile? = nil, to newDirection: MoveDirection? = nil, newTile: Tile? = nil) {
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
    
    func removeHighlight() {
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 0
    }
    
    func decorateRunnerHighlight() {
        if self.type == .basic {
            self.layer.borderWidth = 2
            self.layer.borderColor = UIColor(named: "Red")?.withAlphaComponent(0.3).cgColor
        }
    }
    
    func decorateSeekerHighlight() {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.systemGreen.withAlphaComponent(0.3).cgColor
    }
    
    func decorateOuter() {
        self.backgroundColor = .clear
    }
    
    func decorateExit() {
        self.backgroundColor = UIColor(named: "Black")
        self.imageView.image = UIImage(systemName: "flag.checkered")
        self.imageView.tintColor = UIColor(named: "Background")
    }
    
    func decorateClosed() {
        self.backgroundColor = UIColor(named: "Gray")
        self.imageView.image = UIImage(systemName: "minus.circle.fill")
    }
    
    func decorateSpawn() {
        self.backgroundColor = UIColor(named: "Black")
        self.imageView.image = UIImage(systemName: "house.fill")
        self.imageView.tintColor = UIColor(named: "Background")
    }
    
    func decorateRunner() {
        self.backgroundColor = UIColor(named: "Red")
        self.imageView.image = UIImage(systemName: "face.smiling.fill")
    }
    
    func decorateRunnerWin() {
        self.backgroundColor = .systemGreen
        self.imageView.image = UIImage(systemName: "flag.checkered.2.crossed")
    }
    
    func decorateSeekerWin() {
        self.backgroundColor = .systemGreen
        self.imageView.image = UIImage(systemName: "figure.walk")
    }
    
    private func setDirectionImages(newDirection: ArrowDirection, oldDirection: ArrowDirection, for oldTile: Tile?) {
        self.decorateRunner()
        
        guard oldTile?.type != .start else { return }
        oldTile?.setDirectionImage(to: oldDirection)
        oldTile?.backgroundColor = UIColor(named: "Red")?.withAlphaComponent(0.5)
    }
        
    private func setDirectionImage(to direction: ArrowDirection) {
        switch direction {
        case .up:
            self.imageView.image = UIImage(systemName: "arrow.up")
        case .right:
            self.imageView.image = UIImage(systemName: "arrow.right")
        case .down:
            self.imageView.image = UIImage(systemName: "arrow.down")
        case .left:
            self.imageView.image = UIImage(systemName: "arrow.left")
        case .upLeft:
            self.imageView.image = UIImage(systemName: "arrow.turn.up.left")
        case .upRight:
            self.imageView.image = UIImage(systemName: "arrow.turn.up.right")
        case .rightUp:
            self.imageView.image = UIImage(systemName: "arrow.turn.right.up")
        case .rightDown:
            self.imageView.image = UIImage(systemName: "arrow.turn.right.down")
        case .downRight:
            self.imageView.image = UIImage(systemName: "arrow.turn.down.right")
        case .downLeft:
            self.imageView.image = UIImage(systemName: "arrow.turn.down.left")
        case .leftDown:
            self.imageView.image = UIImage(systemName: "arrow.turn.left.down")
        case .leftUp:
            self.imageView.image = UIImage(systemName: "arrow.turn.left.up")
        case .unknown:
            break;
        }
    }
    
    private func setupImageView() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.image = nil
        self.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])

        self.imageView.tintColor = .white
    }
}
