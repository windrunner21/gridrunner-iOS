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
    
    case resetPassword
    
    case user
    
    case createRoom
    case joinRoom
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
        case .resetPassword:
            return "/sendResetPasswordLink"
        case .user:
            return "/user"
        case .createRoom:
            return "/grid/createGridRoom"
        case .joinRoom:
            return "/grid/joinGridRoom"
        }
    }
}
