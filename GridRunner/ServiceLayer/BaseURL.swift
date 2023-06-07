//
//  BaseURL.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 05.06.23.
//

enum BaseURL {
    case serverless
    case gameServer
}


extension BaseURL {
    var url: String {
        switch self {
        case .serverless:
            return "https://gridrun.live/api"
        case .gameServer:
            return "https://api.gridrun.live"
        }
    }
}
