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
    
    // MARK: TO-DO
    // Create Secret Type
    let secret: String // Base32-encoded string
}
