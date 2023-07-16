//
//  RoleTypeExtension.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 17.07.23.
//

extension RoleType {
    var value: String {
        switch self {
        case .runner:
            return "runner"
        case .seeker:
            return "seeker"
        case .random:
            return "random"
        }
    }
}
