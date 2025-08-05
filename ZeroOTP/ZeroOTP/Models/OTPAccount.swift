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
    let base32String: String
    
    var secret: OTPSecret? {
        let secret = OTPSecret(base32String: base32String)
        
        if secret.validate() {
            return secret
        }
        
        return nil
    }
}
