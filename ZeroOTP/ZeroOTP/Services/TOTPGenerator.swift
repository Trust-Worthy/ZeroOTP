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
    let digits: Int = 6
    let timeInterval: Int = 30
    let algorithm: OTPAlgorithm = .sha1
    let totpObjecct: TOTP
    
   
    init?(_ data: Data) {
        
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
