//
//  APIClient.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 05.06.23.
//

import Foundation

class APIClient {
    private let session: URLSession
    private let baseURL: BaseURL
    private let interceptor: RequestInterceptor?
    
    init(baseURL: BaseURL,interceptor: RequestInterceptor? = nil) {
        self.baseURL = baseURL
        self.interceptor = interceptor
        
        let configuration = URLSessionConfiguration.default
        self.session = URLSession(configuration: configuration)
    }
    
    func sendRequest(
        path: String,
        method: HTTPMethod,
        parameters: Data? = nil,
        headers: [String: String]? = nil,
        customInterceptor: RequestInterceptor? = nil,
        completion: @escaping(Data?, URLResponse?, Error?) -> Void) {
            let url = URL(string: baseURL.url + path)!
            
            var request = URLRequest(url: url)
            
            request.httpMethod = method.rawValue
            
            request.allHTTPHeaderFields = headers
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            request.httpBody = parameters
            
            if let customInterceptor = customInterceptor {
                customInterceptor.intercept(request: &request)
            } else if let interceptor = self.interceptor {
                interceptor.intercept(request: &request)
            }
            
            let task = self.session.dataTask(with: request) { data, response, error  in
                completion(data, response, error)
            }
            
            task.resume()
    }
    
    func getCookie(from response: HTTPURLResponse, from url: URL) {
        if let headers = response.allHeaderFields as? [String: String] {
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: headers, for: url)
            for cookie in cookies {
                if cookie.name == "gridrun-session" {
                    UserDefaults.standard.setValue(cookie, forKey: "session")
                }
            }
        }
    }
}
