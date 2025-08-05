//
//  AESKeyManager.swift
//  ZeroOTP
//
//  Created by Trust-Worthy on 8/5/25.
//

import Foundation
import CryptoKit


class AESKeyManager {
    
    static let shared = AESKeyManager()
    
    private let wrappedKeyKeychainKey = "wrappedAESKey"
    private var cachedKey: SymmetricKey?
    
    
    private init() {}
    
    
    func getSymmetricKey() -> SymmetricKey? {
        // Return from memory if already unqrapped
        if let key = cachedKey {
            return key
        }
        
        // Try to load wrapped key from Keychain
        guard let wrappedData = KeychainHelper.loadDad(forKey: wrappedKeyKeychainKey),
              let unwrapped = SecureEnclaveHelper.unwrapKey(wrappedData) else {
            print("❌ Failed to retrieve or unwrap AES key")
                        return nil
        }
        
        cachedKey = unwrapped
        return unwrapped
    }
    
    func generateAndStoreSymmetricKey() -> Bool {
            let key = SymmetricKey(size: .bits256)
            
            guard let wrapped = SecureEnclaveHelper.wrapKey(key) else {
                print("❌ Failed to wrap AES key")
                return false
            }

            // Store the wrapped key in Keychain
            KeychainHelper.save(wrapped, forKey: wrappedKeyKeychainKey)

            cachedKey = key
            return true
        }
}

