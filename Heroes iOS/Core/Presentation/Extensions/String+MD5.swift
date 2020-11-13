//
//  String+MD5.swift
//  Heroes iOS
//
//  Created by TR64UV on 13/11/2020.
//

import Foundation
import CommonCrypto
extension String {
    var md5: String {
        let data = Data(self.utf8)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            // I first use SHA_256 and it didn't work. So I have to downgrade to CC_MD5
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
