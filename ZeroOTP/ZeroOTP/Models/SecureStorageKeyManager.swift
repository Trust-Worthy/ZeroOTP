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
    
    static func getOrCreateStorageKey() -> String? {
        
        // Try to fetch the key from Keychain
        if let existingKey = readKeychain() {
            return existingKey
        }
        
        // Generate a new random key
        let randomKey = "zk_" + UUID().uuidString.prefix(8)
        
        // Save to Keychain
        if storeInKeychain(randomKey: String(randomKey)) {
            return String(randomKey)
        }
        
        return nil
    }
    
    
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
            
        }
        
        return key
    }
    
    private static func storeInKeychain(randomKey: String) -> Bool {
        let data = Data(randomKey.utf8)
        
        let query: [String: Any] = [
                   kSecClass as String: kSecClassGenericPassword,
                   kSecAttrAccount as String: keychainKey,
                   kSecValueData as String: data,
                   kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
               ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        return status == errSecSuccess
    }
}
