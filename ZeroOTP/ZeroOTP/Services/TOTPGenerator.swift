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
    let totpObjecct: TOTP
    
   
    init?(_ secret: OTPSecret, digits: Int = 6, timeInterval: Int = 30, algorithm: OTPAlgorithm = .sha256) {
        
        guard let secret else {
            
        }
        
        self.totpObjecct = TOTP(secret: OTPSecret.secretData, digits: digits,timeInterval: timeInterval, algorithm: algorithm)
    }
   
    
    
    // Retrieve the current password based on the current time.
    // Return is as an optional in case something went wrong
    func getCurrentPassword() -> String? {
        
        guard let totp = totpObject else {
            return nil
        }
        
        return totp.generate(time: Date.now) ?? "000000"
    }
    
   
    
}
