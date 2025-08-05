//
//  OTPAccount.swift
//  ZeroOTP
//
//  Created by Trust-Worthy on 7/17/25.
//

import Foundation

struct OTPAccount {
    
    let accountName: String
    let dateAdded: Date
    let codeGenerator: TOTPGenerator
    
    
    init?(accountName: String, dateAdded: Date, otpSecret: OTPSecret) {
        self.accountName = accountName
        self.dateAdded = dateAdded
        
    
        guard let generator = TOTPGenerator(secret: otpSecret) else {
            return nil
        }
        
        self.codeGenerator = generator
    }
}
