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
        
        // query for storing the item
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
        // Item is converted into bytes which is the Data type
        SecItemAdd(query as CFDictionary, nil)
        
    }
    
    static func load(forKey key: String) -> String? {
        
        // query for reading the item
        let query: [String: Any] = [
            // Specify generic password
            kSecClass as String: kSecClassGenericPassword,
            
            // pass the key
            kSecAttrAccount as String: key,
            
            // ask for actual data to be returned
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        // tries to find the item and put store it at mem of item
        var item: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &item)
        
        // Convert data from bytes to String
        if let data = item as? Data {
            return String(data: data, encoding: .utf8)
        }
    }
    
    static func delete(forKey key: String) {
        
        // query to delete item associated with key
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        SecItemDelete(query as CFDictionary)
    }
        
}
