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
    
    
    init(accountName: String, dateAdded: Date, codeGenerator: TOTPGenerator) {
        self.accountName = accountName
        self.dateAdded = dateAdded
        self.codeGenerator = codeGenerator
    }
}
