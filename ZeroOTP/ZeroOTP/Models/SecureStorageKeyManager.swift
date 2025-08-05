//
//  SecureStorageKeyManager.swift
//  ZeroOTP
//
//  Created by Trust-Worthy on 8/5/25.
//

import Foundation
import Security

enum SecureStorageKeyManager {
    
    private static let keychainKey = "zk_storage_key"
    
    /// Retrieves an existing key from Keychain or generates and stores a new one
    static func getOrCreateStorageKey() -> String? {
        
        // Try to fetch existing key
        if let existingKey = readKeychain() {
            return existingKey
        }
        
        // Generate a new random key (non-sensitive)
        let generatedKey = "zk_" + UUID().uuidString.prefix(8)
        
        // Save to Keychain
        if storeInKeychain(generatedKey: String(generatedKey)) {
            return String(generatedKey)
        }
        
        return nil
    }
    
    /// Attempts to read the key from the Keychain
    private static func readKeychain() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keychainKey,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let key = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return key
    }
    
    /// Stores a newly generated key in the Keychain
    private static func storeInKeychain(generatedKey: String) -> Bool {
        let data = Data(generatedKey.utf8)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keychainKey,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        return status == errSecSuccess
    }
    
    static func deleteStorageKey() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keychainKey
        ]
        
        SecItemDelete(query as CFDictionary)
    }

}

