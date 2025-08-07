//
//  OTPAccount.swift
//  ZeroOTP
//
//  Created by Trust-Worthy on 7/17/25.
//

import Foundation

struct OTPAccount: Codable{
    
    let accountName: String
    let dateAdded: Date
    private(set) var codeGenerator: TOTPGenerator?
    let otpSecret: OTPSecret
    
    enum CodingKeys: String, CodingKey {
        case accountName
        case dateAdded
        case otpSecret
    }
    
    init(accountName: String, dateAdded: Date, secret: OTPSecret) {
        self.accountName = accountName
        self.dateAdded = dateAdded
        self.otpSecret = secret
        self.codeGenerator = TOTPGenerator(secret: secret, algorithm: .sha1)
    }
    
    // This init is used when decoding from disk/storage
    init(accountName: String, dateAdded: Date, otpSecret: OTPSecret) {
        self.accountName = accountName
        self.dateAdded = dateAdded
        self.otpSecret = otpSecret
        self.codeGenerator = TOTPGenerator(secret: otpSecret, algorithm: .sha1)
    }
    
//    init(accountName: String, dateAdded: Date) {
//        self.accountName = accountName
//        self.dateAdded = dateAdded
//        self.codeGenerator = nil
//    }
    
    /// Fetches secret from SecureOTPStore and reinitializes generator
//    func unlockGenerator(completion: @escaping (Bool) -> Void) {
//        SecureOTPStore.shared.unlockSecret(for: accountName) { [weak self] secret in
//            guard let self = self else {
//                completion(false)
//                return
//            }
//            if let secret = secret {
//                self.codeGenerator = TOTPGenerator(secret: secret)
//                completion(true)
//            } else {
//                completion(false)
//            }
//        }
//    }
    
    // MARK: Test func to validate TOTP functionality
    
    
    /// Optional shortcut to get current code
    func currentOTPCode() -> String? {
        return codeGenerator?.generateCurrentCode()
    }
    
    
}


extension OTPAccount {
    
    static var otpAccountsKey: String {
        return "UserOTPAccounts"
    }
    
    // Given an array of accounts, encodes the account to data and saves to UserDefaults
    static func saveOTPAccount(accounts: [OTPAccount], forAccountKey key: String) {
        
        // Save the OTPaccount
        let defaults = UserDefaults.standard
        
        let encodedData = try! JSONEncoder().encode(accounts)
        
        defaults.set(encodedData, forKey: key)
    }
    
    // Retrieve an array of saved account from UserDefaults
//    static func retrieveOTPAccounts(forAccountKey key: String) -> [OTPAccount] {
//        
//        // Get the array of saved tasks from UserDefaults
//        let defaults = UserDefaults.standard
//        
//        if let data = defaults.data(forKey: key) {
//            
//            let decodedAccounts = try! JSONDecoder().decode([OTPAccount].self, from: data)
//            return decodedAccounts
//        } else {
//            // Normally here I would throw an error or something here
//            return []
//        }
//        
//        
//    }
//    
    
    static func retrieveOTPAccounts(forAccountKey key: String) -> [OTPAccount] {
        if let data = UserDefaults.standard.data(forKey: key),
           var decoded = try? JSONDecoder().decode([OTPAccount].self, from: data) {
            
            // Regenerate TOTPGenerators
            for index in decoded.indices {
                decoded[index].codeGenerator = TOTPGenerator(secret: decoded[index].otpSecret)
            }
            
            return decoded
        }
        return []
    }
    
    
    // Adds the OTP account to the accounts array in UserDefaults.
    func addUserOTPAccount() {
        
        // Open
        // Get all OTP Accounts for specific user from UserDefaults
        var existingOTPAccounts = OTPAccount.retrieveOTPAccounts(forAccountKey: OTPAccount.otpAccountsKey)
        // Add
        // Add the new OTP account to the array of existing accounts
        // This method is available on instances so I can save self
        existingOTPAccounts.append(self)
        
        // Close
        // Save the updated OTP Accounts array
        OTPAccount.saveOTPAccount(accounts: existingOTPAccounts, forAccountKey: OTPAccount.otpAccountsKey)
        
        
    }
    
    // MARK: Add a remove account / transfer account
    
    
}
