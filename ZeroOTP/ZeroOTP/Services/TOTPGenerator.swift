//
//  TOTPGenerator.swift
//  ZeroOTP
//
//  Created by Trust-Worthy on 7/17/25.
//

import SwiftOTP
import UIKit


/// Generates time-based one-time passwords using a securely wrapped OTP secret.
struct TOTPGenerator {
    
    // MARK: - Properties
    
    /// The user's decoded secret
    private let otpSecret: OTPSecret
   
    /// Number of digits in the generated OTP (typically 6)
    private let digits: Int
        
    /// Time step in seconds (usually 30s)
    private let timeInterval: Int
    
    /// HMAC hashing algorithm (e.g., SHA1, SHA256)
    private let algorithm: OTPAlgorithm
    
    
    /// Initialize a generator with a validated OTPSecret and optional config
    init?(secret: OTPSecret, digits: Int = 6, timeInterval: Int = 30, algorithm: OTPAlgorithm = .sha256) {
        self.otpSecret = secret
        self.digits = digits
        self.timeInterval = timeInterval
        self.algorithm = algorithm

        // Sanity check: try creating TOTP object once to ensure parameters are valid
        guard TOTP(secret: otpSecret.getSecretData(), digits: digits, timeInterval: timeInterval, algorithm: algorithm) != nil else {
            return nil
        }
    }
    
    
    
    
    
    // MARK: - OTP Code Generation

   /// Generate the current OTP code based on system time
   /// Returns nil if TOTP generation fails
   func generateCurrentCode() -> String? {
       guard let totp = TOTP(secret: otpSecret.getSecretData(), digits: digits, timeInterval: timeInterval, algorithm: algorithm) else {
           return nil
       }
       return totp.generate(time: Date())
   }

}
