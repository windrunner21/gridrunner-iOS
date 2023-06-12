//
//  URLPath.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 06.06.23.
//

enum URLPath {
    case login
    case register
    case logout
    case user
}

extension URLPath {
    var path: String {
        switch self {
        case .login:
           return "/login"
        case .register:
           return "/signup"
        case .logout:
            return "/logout"
        case .user:
            return "/user"
        }
    }
}
