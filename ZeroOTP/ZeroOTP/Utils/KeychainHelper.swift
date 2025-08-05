//
//  KeychainHelper.swift
//  ZeroOTP
//
//  Created by Trust-Worthy on 8/4/25.
//

import Foundation
import Security

enum KeychainHelper {
    
    // MARK: - Store Wrapped (Encrypted) Key
    
    /// Stores encrypted key data into the Keychain using biometric protection
    static func storeWrappedKey(_ keyData: Data, forKey key: String) -> Bool {
        let accessControl = SecAccessControlCreateWithFlags(
            nil,
            kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
            [.privateKeyUsage, .userPresence], // Require Face ID / passcode
            nil
        )!

        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: key,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecValueData as String: keyData,
            kSecAttrAccessControl as String: accessControl
        ]
        
        // Ensure no duplicate
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        
        return status == errSecSuccess
    }
    
    // MARK: - Load Wrapped Key
    
    /// Retrieves encrypted key data from the Keychain
    static func loadWrappedKey(forKey key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: key,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess else {
            debugPrint("Keychain load error: \(readableError(for: status))")
            return nil
        }
        
        return item as? Data
    }
    
    // MARK: - Delete Wrapped Key
    
    static func deleteWrappedKey(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
    
    // MARK: - Optional: Legacy Generic Password (String Storage)

    static func saveString(_ value: String, forKey key: String) {
        let data = Data(value.utf8)

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    static func loadString(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess, let data = item as? Data else {
            debugPrint("Keychain load error: \(readableError(for: status))")
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }

    static func deleteString(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        SecItemDelete(query as CFDictionary)
    }

    // MARK: - Debug Helper

    private static func readableError(for status: OSStatus) -> String {
        switch status {
        case errSecSuccess: return "Success"
        case errSecItemNotFound: return "Item not found"
        case errSecDuplicateItem: return "Duplicate item"
        case errSecAuthFailed: return "Authentication failed"
        default: return "Unhandled Keychain error: \(status)"
        }
    }
}

