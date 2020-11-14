//
//  APIEndpoints.swift
//  Heroes iOS
//
//  Created by TR64UV on 09/11/2020.
//

import Foundation
/// The API endpoint struct
struct APIEndpoints {
    /// We create the Character endpoint
    /// - Parameter offset: This params support us to load more data
    /// - Returns: It return the final endpoint already constructed
    static func getCharacters(offset: Int) -> URLRequest? {
        return Endpoint(path: Constants.Endpoints.characters,
                        queries: [Constants.NetworkConfiguration.timestamp: Constants.NetworkConfiguration.timestampData,
                                  Constants.NetworkConfiguration.apiKey: Constants.NetworkConfiguration.publicKey,
                                  Constants.NetworkConfiguration.hash: Constants.NetworkConfiguration.md5Hash,
                                  Constants.NetworkConfiguration.limit: Constants.NetworkConfiguration.maxElement,
                                  Constants.NetworkConfiguration.offset: String(describing:offset)],
                        method: .get).create()
    }
}

