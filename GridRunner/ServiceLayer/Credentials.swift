//
//  Credentials.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 05.06.23.
//

import Foundation

protocol Credentials {
    var username: String { get }
    var password: String { get }
    
    func encode() -> Data?
}
