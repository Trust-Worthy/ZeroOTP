//
//  BiometricHelperTests.swift
//  ZeroOTP
//
//  Created by Trust-Worthy on 8/5/25.
//

import XCTest
import LocalAuthentication
@testable import ZeroOTP

// MARK: - Mock Context

class MockLAContext: LAContext {
    var canEvaluate = true
    var shouldSucceed = true
    var expectedError: Error?

    override func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool {
        return canEvaluate
    }

    override func evaluatePolicy(_ policy: LAPolicy, localizedReason: String, reply: @escaping (Bool, Error?) -> Void) {
        reply(shouldSucceed, expectedError)
    }
}

// MARK: - Tests

final class BiometricHelperTests: XCTestCase {
    
    func testAuthenticationSuccess() {
        let mockContext = MockLAContext()
        mockContext.shouldSucceed = true
        
        let expectation = self.expectation(description: "Biometric Auth Succeeds")
        
        BiometricHelper.authenticate(reason: "Test", context: mockContext) { success, error in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
    
    func testAuthenticationFailure() {
        let mockContext = MockLAContext()
        mockContext.shouldSucceed = false
        mockContext.expectedError = NSError(domain: LAError.errorDomain, code: LAError.authenticationFailed.rawValue, userInfo: nil)

        let expectation = self.expectation(description: "Biometric Auth Fails")
        
        BiometricHelper.authenticate(reason: "Test", context: mockContext) { success, error in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }

    func testCannotEvaluatePolicy() {
        let mockContext = MockLAContext()
        mockContext.canEvaluate = false
        mockContext.expectedError = NSError(domain: LAError.errorDomain, code: LAError.biometryNotAvailable.rawValue, userInfo: nil)

        let expectation = self.expectation(description: "Cannot Evaluate Policy")

        BiometricHelper.authenticate(reason: "Test", context: mockContext) { success, error in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertEqual((error! as NSError).code, LAError.biometryNotAvailable.rawValue)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }
}
