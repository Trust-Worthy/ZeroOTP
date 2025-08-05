//
//  UserOTPAccounts.swift
//  ZeroOTP
//
//  Created by Trust-Worthy on 8/5/25.
//

import Foundation
import Security

struct UserOTPAccounts {
    
    static func getUserAccounts() -> [OTPAccount] {
        guard let storageKey = SecureStorageKeyManager.getOrCreateStorageKey(),
              let encryptedData = UserDefaults.standard.data(forKey: storageKey),
              let aesKey = AESKeyManager
    }
}
