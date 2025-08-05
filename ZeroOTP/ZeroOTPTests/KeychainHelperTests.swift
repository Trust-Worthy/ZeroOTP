//
//  KeychainHelperTests.swift
//  ZeroOTP
//
//  Created by Trust-Worthy on 8/5/25.
//

import XCTest
@testable import ZeroOTP

final class KeychainHelperTests: XCTestCase {
    
    let testKey = "com.zerootp.testKey"
    let testValue = "helloWorld"
    
    func testSaveAndLoadString() {
        KeychainHelper.saveString(testValue, forKey: testKey)
        let loaded = KeychainHelper.loadString(forKey: testKey)
        XCTAssertEqual(loaded, testValue)
    }
    
    func testDeleteString() {
        KeychainHelper.saveString(testValue, forKey: testKey)
        KeychainHelper.deleteString(forKey: testKey)
        let deleted = KeychainHelper.loadString(forKey: testKey)
        XCTAssertNil(deleted)
    }

    func testStoreAndLoadWrappedKey() {
        let dummyData = "dummy-secret-key".data(using: .utf8)!
        let success = KeychainHelper.storeWrappedKey(dummyData, forKey: testKey)
        XCTAssertTrue(success)
        
        let loaded = KeychainHelper.loadWrappedKey(forKey: testKey)
        XCTAssertEqual(loaded, dummyData)
    }

    func testDeleteWrappedKey() {
        let dummyData = "dummy-secret-key".data(using: .utf8)!
        _ = KeychainHelper.storeWrappedKey(dummyData, forKey: testKey)
        KeychainHelper.deleteWrappedKey(forKey: testKey)
        
        let loaded = KeychainHelper.loadWrappedKey(forKey: testKey)
        XCTAssertNil(loaded)
    }
}
