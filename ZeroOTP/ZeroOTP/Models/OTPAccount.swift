//
//  OTPAccount.swift
//  ZeroOTP
//
//  Created by Trust-Worthy on 7/17/25.
//

import Foundation

final class OTPAccount: Codable {
    
    let accountName: String
    let dateAdded: Date
    private(set) var codeGenerator: TOTPGenerator?
    
    init(accountName: String, dateAdded: Date, secret: OTPSecret) {
        self.accountName = accountName
        self.dateAdded = dateAdded
        self.codeGenerator = TOTPGenerator(secret: secret)
    }
    
//    init(accountName: String, dateAdded: Date) {
//        self.accountName = accountName
//        self.dateAdded = dateAdded
//        self.codeGenerator = nil
//    }
    
    /// Fetches secret from SecureOTPStore and reinitializes generator
    func unlockGenerator(completion: @escaping (Bool) -> Void) {
        SecureOTPStore.shared.unlockSecret(for: accountName) { [weak self] secret in
            guard let self = self else {
                completion(false)
                return
            }
            if let secret = secret {
                self.codeGenerator = TOTPGenerator(secret: secret)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    // MARK: Test func to validate TOTP functionality
    
    
    /// Optional shortcut to get current code
    func currentOTPCode() -> String? {
        return codeGenerator?.generateCurrentCode()
    }
    
    
}


extension OTPAccount {
    
    // Given an account, encodes the account to data and saves to UserDefaults
    static func saveAccount(account: OTPAccount, forAccountKey key: String) {
        
        // Save the OTPaccount
        let defaults = UserDefaults.standard
        
        let encodedData = try! JSONEncoder().encode(account)
        
        defaults.set(encodedData, forKey: key)
    }
    
    // 
    
    static func retrieveAccounts() {
        
    }
}
