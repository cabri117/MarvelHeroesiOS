//
//  Endpoint.swift
//  Heroes iOS
//
//  Created by TR64UV on 13/11/2020.
//
import Foundation
/// Endpoints constructor struct
struct Endpoint {
    let path: String
    let queries: [String: String]
    let method: HTTPMethod
    /// Method to create the encpoint
    /// - Returns: We return the final URL Request
    func create() -> URLRequest? {
        guard var components = URLComponents(string: "\(Constants.url)\(path)") else {
            return nil
        }
        components.queryItems = queries.map { key, value in
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
