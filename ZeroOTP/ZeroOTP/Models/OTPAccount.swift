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
    private(set) var codeGenerator: TOTPGenerator?
    
    init(accountName: String, dateAdded: Date) {
        self.accountName = accountName
        self.dateAdded = dateAdded
        self.codeGenerator = nil
    }
    
    /// Fetches secret from SecureOTPStore and reinitializes generator
    mutating func unlockGenerator(completion: @escaping (Bool) -> Void) {
        SecureOTPStore.shared.unlockSecret(for: accountName) { secret in
            if let secret = secret {
                self.codeGenerator = TOTPGenerator(secret: secret)
                completion(true)
            } else {
                completion(false)
            }
        }
        
        
    }
    
    /// Optional shortcut to get current code
    func currentOTPCode() -> String? {
        return codeGenerator?.generateCurrentCode()
    }
}
