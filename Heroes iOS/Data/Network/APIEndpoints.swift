//
//  APIEndpoints.swift
//  Heroes iOS
//
//  Created by TR64UV on 09/11/2020.
//

import Foundation
struct APIEndpoints {
    
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

