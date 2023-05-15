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
    }
    
    func setDirectionImage(to direction: MoveDirection) {
        switch direction {
        case .up:
            self.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        case .right:
            self.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        case .down:
            self.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        case .left:
            self.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        default:
            break
        }
    }
}
