//
//  OTPSecretTests.swift
//  ZeroOTP
//
//  Created by Trust-Worthy on 8/5/25.
//

import XCTest
import SwiftOTP
@testable import ZeroOTP

final class OTPSecretTests: XCTestCase {
    
    
    func testInit_withValidBase32String_succeeds() {
            let validBase32 = "JBSWY3DPEHPK3PXP"
            let secret = OTPSecret(validBase32)
            XCTAssertNotNil(secret, "Should initialize with valid Base32 string")
    }
    
    
    func testInit_withInvalidBase32String_fails() {
        let invalidBase32 = "INVALID$$$"
        let secret = OTPSecret(invalidBase32)
        XCTAssertNil(secret, "Should fail to initialize with invalid Base32 string")
    }
    
    func testIsValid_returnsTrue_forValidSecret() {
            let secret = OTPSecret("JBSWY3DPEHPK3PXP")!
            XCTAssertTrue(secret.isValid(), "isValid() should return true for valid Base32 secret")
    }

    func testIsValid_returnsFalse_forInvalidBase32() {
           // Since init fails for invalid base32, this test verifies static method
           XCTAssertFalse(OTPSecret.isValidBase32("INVALID$$$"), "isValidBase32 should return false for invalid string")
    }
    
    
    func testSecretData_decodesCorrectly() {
            let base32 = "JBSWY3DPEHPK3PXP"
            let secret = OTPSecret(base32)!
            let expectedData = base32DecodeToData(base32)
            XCTAssertEqual(secret.getSecretData(), expectedData, "secretData should decode base32 string correctly")
    }
    
    
}
