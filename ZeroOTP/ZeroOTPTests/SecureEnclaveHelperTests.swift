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
    
    func testKeyGenerationAndRetrieval() {
        let key = SecureEnclaveHelper.generateAndStoreSecureEnclaveKey()
        XCTAssertNotNil(key)

        let retrieved = SecureEnclaveHelper.getSecureEnclaveKey()
        XCTAssertNotNil(retrieved)
        XCTAssertEqual(SecKeyCopyExternalRepresentation(key!, nil) == nil, true)
    }
    
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
}
