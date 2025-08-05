//
//  TOTPGenerator.swift
//  ZeroOTP
//
//  Created by Trust-Worthy on 7/17/25.
//

import SwiftOTP
import UIKit

struct TOTPGenerator {
    
    let secret: OTPSecret
    let digits: Int = 6
    let timeInterval: Int = 30
    let algorithm: OTPAlgorithm = .sha1

    
    // Computed property that returns a TOTP object with customized parameters.
    // If all params aren't met for the constructor, a standard TOTP object is created with the default values.
    var totpObject: TOTP? {
        TOTP(secret: secret.secretData, digits: digits, timeInterval: timeInterval, algorithm: algorithm)
        ?? TOTP(secret: secret.secretData)
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
