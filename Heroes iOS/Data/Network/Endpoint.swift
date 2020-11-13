//
//  Endpoint.swift
//  Heroes iOS
//
//  Created by TR64UV on 13/11/2020.
//

import Foundation
struct Endpoint {
    let path: String
    let queries: [String: String]
    let method: HTTPMethod
    
    func create() -> URLRequest? {
        guard var components = URLComponents(string: "https://gateway.marvel.com/v1/public/\(path)") else {
            return nil
        }
        components.queryItems = queries.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        guard let url = components.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
