//
//  Tile.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 12.05.23.
//

import UIKit

class Tile: UIButton {
    
    private var identifier: String = String()
    var type: TileType = .unknown
    private var hasBeenOpened: Bool = false
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
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
}
