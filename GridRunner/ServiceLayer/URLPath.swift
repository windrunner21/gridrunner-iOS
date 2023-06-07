//
//  URLPath.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 06.06.23.
//

enum URLPath {
    case login
    case register
}

extension URLPath {
    var path: String {
        switch self {
        case .login:
           return "/login"
        case .register:
           return "/signup"
        }
    }
}
