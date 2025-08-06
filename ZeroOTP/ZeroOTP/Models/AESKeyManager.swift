//
//  AESKeyManager.swift
//  ZeroOTP
//

import Foundation
import CryptoKit

//final class AESKeyManager {
//
//    private static let wrappedKeychainKey = "wrapped.aes.key"
//    private static var cachedKey: SymmetricKey?
//
//    private init() {} // prevent instantiation
//
//    /// Get existing AES key or nil if missing
//    static func getAESKey() -> SymmetricKey? {
//        if let key = cachedKey {
//            return key
//        }
//
//        guard let wrapped = KeychainHelper.loadWrappedKey(forKey: wrappedKeychainKey),
//              let unwrapped = SecureEnclaveHelper.unwrapKey(wrapped) else {
//            print("❌ Failed to retrieve or unwrap AES key")
//            return nil
//        }
//
//        cachedKey = unwrapped
//        return unwrapped
//    }
//
//    /// Get or generate AES key
//    static func getOrCreateAESKey() -> SymmetricKey? {
//        if let key = getAESKey() {
//            return key
//        }
//
//        return generateAndStoreAESKey() ? cachedKey : nil
//    }
//
//    /// Generates a new AES key, wraps it with Secure Enclave, and stores it in Keychain
//    static func generateAndStoreAESKey() -> Bool {
//        let key = SymmetricKey(size: .bits256)
//
//        guard let wrapped = SecureEnclaveHelper.wrapKey(key) else {
//            print("❌ Failed to wrap AES key")
//            return false
//        }
//
//        let stored = KeychainHelper.storeWrappedKey(wrapped, forKey: wrappedKeychainKey)
//        if stored {
//            cachedKey = key
//        }
//        return stored
//    }
//
//    /// Deletes the AES key from memory and Keychain
//    static func deleteAESKey() {
//        cachedKey = nil
//        KeychainHelper.deleteWrappedKey(forKey: wrappedKeychainKey)
//    }
//}
//
