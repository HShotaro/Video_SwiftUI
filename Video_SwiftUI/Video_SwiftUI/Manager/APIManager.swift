//
//  APIManager.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2021/11/19.
//

import Foundation
import Combine

class APIManager {
    enum Method: String {
    case GET
    case POST
    case PUT
    case DELETE
    }
    static let shared = APIManager()
    static let baseURL = "https://hshotaro.com"
    
    private init() {}
    
    static func urlRequest
    (
        path: String,
        method: Method,
        header: [String: String]? = nil,
        body: [String: Any]? = nil
    ) -> AnyPublisher<URLRequest, Never> {
        return Future<URLRequest?, Never> { promise in
            guard let apiURL = URL(string: baseURL + path) else {
                promise(.success(nil))
                return
            }
            var request = URLRequest(url: apiURL)
            request.httpMethod = method.rawValue
            if let header = header {
                header.forEach { (k,v) in
                    request.setValue(v, forHTTPHeaderField: k)
                }
            }
            if let body = body {
                request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
            }
            request.timeoutInterval = 15
            promise(.success(request))
        }.compactMap{ $0 }.eraseToAnyPublisher()
    }
}
