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
    
    // Generates and stores a new EC private key in the Secure Enclave
    static func generateAndStoreSecureEnclaveKey() -> SecKey? {
        guard let access = SecAccessControlCreateWithFlags(nil,
                                                           kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                                                           [.privateKeyUsage, .biometryCurrentSet],
                                                           nil) else {
            print("Failed to create access control")
            return nil
        }
        
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
            print("Secure Enclave Key Generation Failed:", error?.takeRetainedValue().localizedDescription ?? "Unknown error")
            return nil
        }
        
        return privateKey
    }
    
    /// Fetches the previously stored Secure Enclave private key
    static func getSecureEnclaveKey() -> SecKey? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: keyTag,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecReturnRef as String: true
        ]
        
        var keyRef: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &keyRef)
        return status == errSecSuccess ? (keyRef as! SecKey) : nil
    }
        
    
    /// Wraps the given symmetric key using the public EC key from the Secure Enclave
    static func wrapKey(_ symmetricKey: SymmetricKey) -> Data? {
        // Ensure a Secure Enclave key exists
        guard let key = getSecureEnclaveKey() ?? generateAndStoreSecureEnclaveKey(),
              let publicKey = SecKeyCopyPublicKey(key) else {
            print("Missing Secure Enclave key")
            return nil
        }
        
        let keyData = symmetricKey.withUnsafeBytes { Data($0) }
        
        var error: Unmanaged<CFError>?
        guard let encrypted = SecKeyCreateEncryptedData(publicKey,
                                                        .eciesEncryptionCofactorVariableIVX963SHA256AESGCM,
                                                        keyData as CFData,
                                                        &error) else {
            print("Key Wrapping Failed:", error?.takeRetainedValue().localizedDescription ?? "Unknown error")
            return nil
        }
        
        return encrypted as Data
    }
    
    
    // Unwraps previously encrypted symmetric key using Secure Enclave private key
    static func unwrapKey(_ wrappedKey: Data) -> SymmetricKey? {
        guard let privateKey = getSecureEnclaveKey() else {
            print("Missing Secure Enclave private key")
            return nil
        }
        
        var error: Unmanaged<CFError>?
        guard let decrypted = SecKeyCreateDecryptedData(privateKey,
                                                        .eciesEncryptionCofactorVariableIVX963SHA256AESGCM,
                                                        wrappedKey as CFData,
                                                        &error) else {
            print("Key Unwrapping Failed:", error?.takeRetainedValue().localizedDescription ?? "Unknown error")
            return nil
        }
        
        return SymmetricKey(data: decrypted as Data)
    }
}
