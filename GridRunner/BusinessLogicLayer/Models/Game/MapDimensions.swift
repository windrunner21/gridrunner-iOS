//
//  MapDimensions.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 12.05.23.
//

struct MapDimensions {
    private var rows: Int
    private var columns: Int
    typealias Dimensions = (rows: Int, columns: Int)
    
    init() {
        self.rows = 0
        self.columns = 0
    }
    
    init(_ rows: Int, by columns: Int) {
        self.rows = rows
        self.columns = columns
    }
    
    func dimensions() -> Dimensions {
        (rows: rows, columns: columns)
    }
    
    func getNumberOfRows() -> Int {
        rows
    }
    
    func getNumberOfColumns() -> Int {
        columns
    }
}
