//
//  InMemoryOTPSecret.swift
//  ZeroOTP
//
//  Created by Trust-Worthy on 8/4/25.
//


import Foundation
import CryptoKit

class InMemoryOTPSecret {
    
    private let key = SymmetricKey(size: .bits256)
    private var encryptedOTPSecret: Data // Still in binary form
    
    

    init?(otpSecret: String) {
        // takes a plain String secret
        // converts it into Data
        guard let secretData = otpSecret.data(using: .utf8) else {
            // if conversion failes (encoding error) , return nil
            return nil
        }
    }
    
}
