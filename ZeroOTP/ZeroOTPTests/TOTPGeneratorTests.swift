//
//  TOTPGeneratorTests.swift
//  ZeroOTP
//
//  Created by Trust-Worthy on 8/5/25.
//

import XCTest
import SwiftOTP
@testable import ZeroOTP

final class TOTPGeneratorTests: XCTestCase {
    
    func testGeneratorInitializesWithValidSecret() {
        let secret = OTPSecret("JBSWY3DPEHPK3PXP")
        XCTAssertNotNil(secret)

        let generator = TOTPGenerator(secret: secret!)
        XCTAssertNotNil(generator)
    }
    
    func testGeneratorFailsWithInvalidSecret() {
        let secret = OTPSecret("INVALID@@@")
        XCTAssertNil(secret)

        // Can't even initialize TOTPGenerator if OTPSecret fails
        if let invalid = secret {
            let generator = TOTPGenerator(secret: invalid)
            XCTAssertNil(generator)
        }
    }
    
    func testGeneratedCodeHasCorrectLength() {
        let secret = OTPSecret("JBSWY3DPEHPK3PXP")!
        let generator = TOTPGenerator(secret: secret, digits: 8)!
        
        guard let code = generator.generateCurrentCode() else {
            XCTFail("Failed to generate OTP")
            return
        }
        
        XCTAssertEqual(code.count, 8)
    }
    
    func testGeneratedCodesChangeOverTime() {
        let secret = OTPSecret("JBSWY3DPEHPK3PXP")!
        let generator = TOTPGenerator(secret: secret)!

        let code1 = generator.generateCurrentCode()
        sleep(31) // Wait one TOTP time step (default is 30s)
        let code2 = generator.generateCurrentCode()
        
        XCTAssertNotEqual(code1, code2, "OTP should change over time")
    }
    
    func testSameTimeSameCode() {
        let secret = OTPSecret("JBSWY3DPEHPK3PXP")!
        
        let generator = TOTPGenerator(secret: secret)!
        
        let time = Date()
        let code1 = TOTP(secret: secret.getSecretData())?.generate(time: time)
        let code2 = generator.generateCurrentCode()

        XCTAssertEqual(code1, code2)
    }

    func testMultipleAlgorithms() {
        let secret = OTPSecret("JBSWY3DPEHPK3PXP")!
        
        for algo in [OTPAlgorithm.sha1, .sha256, .sha512] {
            let generator = TOTPGenerator(secret: secret, digits: 6, timeInterval: 30, algorithm: algo)
            XCTAssertNotNil(generator)
            XCTAssertNotNil(generator?.generateCurrentCode())
        }
    }
}
