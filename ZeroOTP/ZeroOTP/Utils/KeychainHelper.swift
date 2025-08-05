//
//  KeychainHelper.swift
//  ZeroOTP
//
//  Created by Trust-Worthy on 8/4/25.
//

import Foundation
import Security

struct KeychainHelper {
    
    static func save(_ value: String, forKey key: String) {
        let data = Data(value.utf8)
        
        let query: [String: Any] = [
            
            // Storing a generic password type item
            kSecClass as String: kSecClassGenericPassword,
            
            // Key under which value will be stored
            kSecAttrAccount as String: key,
            
            // The data (value) that will be stored
            kSecValueData as String: data,
            
            // Controls when the data is accessible
            // Only after the device is unlocked
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        // Removes any existing item with this key
        SecItemDelete(query as CFDictionary)
        
        // Adds new item
        SecItemAdd(query as CFDictionary, nil)
        
    }
    
    static func load(forKey key: String) -> String? {
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
    }
        
}
