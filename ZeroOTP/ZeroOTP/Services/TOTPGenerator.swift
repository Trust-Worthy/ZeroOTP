//
//  TOTPGenerator.swift
//  ZeroOTP
//
//  Created by Trust-Worthy on 7/17/25.
//

import SwiftOTP
import UIKit



struct TOTPGenerator {
    
    let OTPSecret: OTPSecret
    let digits: Int
    let timeInterval: Int
    let algorithm: OTPAlgorithm
    var totpObject: TOTP?
    var otpCode: String
    
   
    init?(_ secret: OTPSecret?, digits: Int = 6, timeInterval: Int = 30, algorithm: OTPAlgorithm = .sha256) {
        
        // If secret is nil, fail the initializer
        guard let secret = secret else {
            return nil
        }
        
        self.OTPSecret = secret
        
        
        // Initialie the internal TOTP object
        guard let totp = TOTP(secret: OTPSecret.secretData, digits: digits,timeInterval: timeInterval, algorithm: algorithm) else {
            return nil // Fail if TOTP creation fails
        }
        
        self.digits = digits
        self.timeInterval = timeInterval
        self.algorithm = algorithm
        
        
        self.totpObject = totp
        
        // Get the first code immediately so that it can be shown to the user
        self.otpCode = self.totpObject?.generate(time: Date.now) ?? "000000"
    }
   
    
    
    // Retrieve the current password based on the current time.
    // Return is as an optional in case something went wrong
    
    
    mutating func getCurrentCode() -> String? {
        
        if var validTOTP = self.totpObject {
            otpCode = validTOTP.generate(time: Date.now) ?? "000000"
            return otpCode
        } else {
            return nil
        }
        
        
    }
    
   
    
}
