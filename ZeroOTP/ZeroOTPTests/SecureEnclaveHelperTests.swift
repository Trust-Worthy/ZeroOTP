//
//  SecureEnclaveHelperTests.swift
//  ZeroOTP
//
//  Created by Trust-Worthy on 8/5/25.
//

import XCTest
import CryptoKit
@testable import ZeroOTP

final class SecureEnclaveHelperTests: XCTestCase {
    
    // MARK: Failed Test
    func testKeyGenerationAndRetrieval() {
        let key = SecureEnclaveHelper.generateAndStoreSecureEnclaveKey()
        XCTAssertNotNil(key)

        let retrieved = SecureEnclaveHelper.getSecureEnclaveKey()
        XCTAssertNotNil(retrieved)
        XCTAssertEqual(SecKeyCopyExternalRepresentation(key!, nil) == nil, true)
    }
    
    // MARK: Failed Test
    func testWrapAndUnwrapSymmetricKey() {
        let symmetricKey = SymmetricKey(size: .bits256)
        
        guard let wrapped = SecureEnclaveHelper.wrapKey(symmetricKey) else {
            XCTFail("Failed to wrap symmetric key")
            return
        }
        
        guard let unwrapped = SecureEnclaveHelper.unwrapKey(wrapped) else {
            XCTFail("Failed to unwrap symmetric key")
            return
        }

        XCTAssertEqual(symmetricKey.withUnsafeBytes { Data($0) },
                       unwrapped.withUnsafeBytes { Data($0) },
                       "Unwrapped key does not match original")
    }
    
    // MARK: Failed Test
    func testWrapFailsIfNoKeyAvailable() {
        // Simulate failure by deleting the key (if needed)
        // WARNING: This removes real keys from the Secure Enclave for this app
        // Only use in testing
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: SecureEnclaveHelper.keyTag,
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom
        ]
        SecItemDelete(query as CFDictionary)
        
        // Now try wrapping with no key available
        let key = SymmetricKey(size: .bits256)
        let result = SecureEnclaveHelper.wrapKey(key)
        
        XCTAssertNotNil(result, "Key should be regenerated and wrap should succeed")
    }
    
    func testAESEncryptDecryptRoundTrip() throws {
           let plainText = "Test data for AES encryption"
           let key = SymmetricKey(size: .bits256)
           let data = plainText.data(using: .utf8)!
           
        let encrypted = try AESUtility.encrypt(data, using: key)
           XCTAssertNotEqual(encrypted, data, "Encrypted data should differ from plain data")
           
        let decrypted = try AESUtility.decrypt(encrypted, using: key)
           XCTAssertEqual(decrypted, data, "Decrypted data should match original")
       }
       
    // MARK: Failed Test
       func testSecureEnclaveKeyWrapUnwrap() {
           // Generate a symmetric key to wrap
           let symmetricKey = SymmetricKey(size: .bits256)
           
//           // Generate or get Secure Enclave key
//           guard let seKey = SecureEnclaveHelper.getSecureEnclaveKey() ?? SecureEnclaveHelper.generateAndStoreSecureEnclaveKey() else {
//               XCTFail("Failed to get or generate Secure Enclave key")
//               return
//           }
           // Alternative way of running the test above
           guard (SecureEnclaveHelper.getSecureEnclaveKey() ?? SecureEnclaveHelper.generateAndStoreSecureEnclaveKey()) != nil else {
               XCTFail("Failed to get or generate Secure Enclave key")
               return
           }

           
           // Wrap the symmetric key
           guard let wrappedData = SecureEnclaveHelper.wrapKey(symmetricKey) else {
               XCTFail("Failed to wrap symmetric key")
               return
           }
           
           // Unwrap the symmetric key
           guard let unwrappedKey = SecureEnclaveHelper.unwrapKey(wrappedData) else {
               XCTFail("Failed to unwrap symmetric key")
               return
           }
           
           // The unwrapped key data should equal the original key data
           XCTAssertEqual(symmetricKey.withUnsafeBytes { Data($0) },
                          unwrappedKey.withUnsafeBytes { Data($0) },
                          "Unwrapped key should match original symmetric key")
       }
}
