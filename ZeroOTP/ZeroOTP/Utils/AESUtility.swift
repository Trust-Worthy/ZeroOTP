//
//  AESUtility.swift
//  ZeroOTP
//
//  Created by Trust-Worthy on 8/5/25.
//

import Foundation
import CryptoKit

enum AESUtility {
    
    // Encrypt data with a given symmetric key
    static func encrypt(_ data: Data, using key: SymmetricKey) throws -> Data {
        let sealedBox = try AES.GCM.seal(data, using: key)
        return sealedBox.combined! // combined contains nonce + ciphertext + tag
    }
    
    // Decrypt data with a given symmetric key
    static func decrypt(_ encryptedData: Data, using key: SymmetricKey) throws -> Data {
        let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
        return try AES.GCM.open(sealedBox, using: key)
    }
}
