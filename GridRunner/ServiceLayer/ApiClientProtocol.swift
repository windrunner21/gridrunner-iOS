//
//  ApiClientProtocol.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 03.11.23.
//

import Foundation

protocol ApiClientProtocol {
    func sendRequest(
        path: String, method: HTTPMethod, completion: @escaping(Data?, URLResponse?, Error?) -> Void
    )
    
    func sendRequestWithBody(
        path: String, method: HTTPMethod, body: Data?, completion: @escaping(Data?, URLResponse?, Error?) -> Void
    )
    
    func sendRequestWithParameters(
        path: String, method: HTTPMethod, parameters: [URLQueryItem]?, completion: @escaping(Data?, URLResponse?, Error?) -> Void
    )
    
    func sendRequestWithCookies(
        path: String, method: HTTPMethod, cookies: (name: String, value: String?)?, completion: @escaping(Data?, URLResponse?, Error?) -> Void
    )

    func getCookie(from response: HTTPURLResponse, from url: URL)
    func removeCookie()
}
