//
//  RandomGenerator.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 13.11.23.
//

import Foundation

struct RandomGenerator {
    static func random(a: ()->Void, b: ()-> Void) {
        let randomNumber = arc4random_uniform(2)
        if randomNumber == 0 { a() } else { b() }
    }
}
