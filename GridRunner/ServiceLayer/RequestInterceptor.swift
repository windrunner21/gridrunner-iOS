//
//  RequestInterceptor.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 05.06.23.
//

import Foundation

protocol RequestInterceptor {
    func intercept(request: inout URLRequest)
}
