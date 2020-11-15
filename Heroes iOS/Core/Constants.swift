//
//  Constants.swift
//  Daniel Cabrera
//
//  Created by Daniel Cabrera on 17/08/2020.
//  Copyright © Daniel Cabrera. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let url = "https://gateway.marvel.com/v1/public/"
    struct DataConfiguration {
        static let data = "data"
        static let results = "results"
        static let mimeType = "application/json"
    }
    
    struct Endpoints {
        static let characters = "characters"
    }
    
    struct NetworkConfiguration {
        static let timestamp = "ts"
        static let timestampData = "1"
        static let publicKey = "df7c00808acf1c7802e89eaf43708a75"
        static let privateKey = "2e11030938deee0874493b7fee2aa88ac0da327c"
        static let md5Hash = "\(timestampData)\(privateKey)\(publicKey)".md5
        static let maxElement = "40"
        static let limit = "limit"
        static let hash = "hash"
        static let offset = "offset"
        static let apiKey = "apikey"
    }
}
