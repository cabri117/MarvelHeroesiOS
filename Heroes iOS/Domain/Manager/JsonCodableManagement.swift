//
//  JsonCodableManagement.swift
//  Daniel Cabrra
//
//  Created by Daniel Cabrera on 22/08/2020.
//  Copyright © Daniel Cabrera. All rights reserved.
//

import Foundation

struct JsonCodableManagment {
    static func newJSONDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            decoder.dateDecodingStrategy = .iso8601
        }
        return decoder
    }
    static func newJSONEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            encoder.dateEncodingStrategy = .iso8601
        }
        return encoder
    }
    static func newJSONToDictionary(jsonString: String?) -> [String: Any]? {
        guard let data = jsonString?.data(using: .utf8) else {
            #if DEBUG
            print("Data json string is nil")
            #endif
            return nil
        }
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            #if DEBUG
            print(error.localizedDescription)
            #endif
        }
        return nil
    }
}
