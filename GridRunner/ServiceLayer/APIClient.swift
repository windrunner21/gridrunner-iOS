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
        body: Data? = nil,
        headers: [String: String]? = nil,
        parameters: [URLQueryItem]? = nil,
        cookies: (name: String, value: String?)? = nil,
        customInterceptor: RequestInterceptor? = nil,
        completion: @escaping(Data?, URLResponse?, Error?) -> Void) {
            var url = URL(string: baseURL.url + path)!
            
            // Handle url parameters.
            if let parameters = parameters {
                var urlComponents = URLComponents(string: url.absoluteString)
                urlComponents?.queryItems = parameters
                if let updatedUrl = urlComponents?.url {
                    url = updatedUrl
                }
            }
            
            var request = URLRequest(url: url)
            
            // Handle method.
            request.httpMethod = method.rawValue
            
            // Handle custom headers.
            request.allHTTPHeaderFields = headers
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            // Handle cookies.
            if let cookies = cookies, let cookieValue = cookies.value  {
                request.httpShouldHandleCookies = true
                request.setValue("\(cookies.name)=\(cookieValue)", forHTTPHeaderField: "Cookie")
            }
            
            // Handle body.
            request.httpBody = body
            
            // Handle custom interceptors.
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
                    UserDefaults.standard.setValue(cookie.value, forKey: "session")
                }
            }
        }
    }
    
    func removeCookie() {
        UserDefaults.standard.removeObject(forKey: "session")
    }
}
