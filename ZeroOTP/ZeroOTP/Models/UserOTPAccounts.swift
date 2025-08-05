//
//  UserOTPAccounts.swift
//  ZeroOTP
//
//  Created by Trust-Worthy on 8/5/25.
//

import Foundation
import Security
import CryptoKit

struct StoredOTPAccount: Codable {
    let accountName: String
    let dateAdded: Date
}

final class UserOTPAccounts {
    
    static private let storageKey = "user.otp.accounts"
    
    /// Load all saved account metadata
    static func loadAccounts() -> [StoredOTPAccount] {
        guard let key = AESKeyManager.getOrCreateAESKey(),
              let encryptedData = UserDefaults.standard.data(forKey: storageKey),
              let decryptedData = AES.encryptOrDecrypt(data: encryptedData, key: key, operation: .decrypt),
              let decoded = try? JSONDecoder().decode([StoredOTPAccount].self, from: decryptedData)
        else {
            return []
        }
        return decoded
    }

    /// Save all account metadata
    static func saveAccounts(_ accounts: [StoredOTPAccount]) {
        guard let key = AESKeyManager.getOrCreateAESKey(),
              let data = try? JSONEncoder().encode(accounts),
              let encrypted = AES.encryptOrDecrypt(data: data, key: key, operation: .encrypt)
        else {
            return
        }

        UserDefaults.standard.set(encrypted, forKey: storageKey)
    }

    /// Add a new account metadata entry
    static func addAccount(accountName: String) {
        var existing = loadAccounts()
        let newEntry = StoredOTPAccount(accountName: accountName, dateAdded: Date())
        existing.append(newEntry)
        saveAccounts(existing)
    }

    /// Delete account metadata entry (does not remove secret)
    static func deleteAccount(accountName: String) {
        var existing = loadAccounts()
        existing.removeAll { $0.accountName == accountName }
        saveAccounts(existing)
    }
}
