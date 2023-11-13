//
//  Logging.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 13.11.23.
//

import Foundation

class Log {
    static func data(_ str: String) {
        NSLog("🟡 INFO LOG: \(str)")
    }
    
    static func success(_ str: String) {
        NSLog("🟢 SUCCESS LOG: \(str)")
    }
    
    static func error(_ str: String) {
        NSLog("🔴 ERROR LOG: \(str)")
    }
}
