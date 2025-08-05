//
//  SecureEnclaveHelper.swift
//  ZeroOTP
//
//  Created by Trust-Worthy on 8/4/25.
//

import Foundation
import Security
import CryptoKit

enum SecureEnclaveHelper {
    static let keyTag = "com.zerootp.symmetrickey"
    
    static func generateAndStoreSEcureEnclaveKey() -> SecKey? {
        
        let access = SecAccessControlCreateWithFlags(nil,
                                                     kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                                                     [.privateKeyUsage, .biometryCurrentSet], nil)!
        
        let attributes: [String: Any] = [
            
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrKeySizeInBits as String: 256,
            kSecAttrTokenID as String: kSecAttrTokenIDSecureEnclave,
            kSecAttrLabel as String: keyTag,
            kSecPrivateKeyAttrs as String: [
                kSecAttrIsPermanent as String: true,
                kSecAttrApplicationTag as String: keyTag,
                kSecAttrAccessControl as String: access
            ]
        ]
        
        var error: Unmanaged<CFError>?
        
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            print("Secure Enclave Key Generation Failed:", error!.takeRetainedValue())
            return nil
        }
        
        return privateKey
    }
    
    static func getSecureEn
}
