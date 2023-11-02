//
//  Map.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 12.05.23.
//

class Map {
    private var dimensions: MapDimensions
    private var numberOfExits: Int
    private var centerCoordinates: Coordinate {
        Coordinate(x: dimensions.getNumberOfRows() / 2, y: dimensions.getNumberOfColumns() / 2)
    }
    
    convenience init() {
        self.init(with: MapDimensions())
    }
    
    init(with dimensions: MapDimensions, numberOfExits: Int = 2) {
        self.dimensions = dimensions
        self.numberOfExits = numberOfExits
    }
    
    func getDimensions() -> MapDimensions {
        dimensions
    }
    
    func getCenterCoordinates() -> Coordinate {
        self.centerCoordinates
    }
}
