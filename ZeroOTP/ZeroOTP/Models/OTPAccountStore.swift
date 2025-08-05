//
//  OTPAccountStore.swift
//  ZeroOTP
//
//  Created by Jonathan Bateman on 8/5/25.
//

import Foundation
import CryptoKit

struct StoredOTPAccount: Codable, Equatable {
    let accountName: String
    let dateAdded: Date
}

final class OTPAccountStore {
    
    private static let storageKey = "user.otp.accounts"
    
    static func load() -> [StoredOTPAccount] {
        guard
            let key = AESKeyManager.getOrCreateAESKey(),
            let encrypted = UserDefaults.standard.data(forKey: storageKey),
            let decrypted = try? AESUtility.decrypt(encrypted, using: key),
            let accounts = try? JSONDecoder().decode([StoredOTPAccount].self, from: decrypted)
        else {
            return []
        }
        return accounts
    }
    
    static func save(_ accounts: [StoredOTPAccount]) {
        guard
            let key = AESKeyManager.getOrCreateAESKey(),
            let data = try? JSONEncoder().encode(accounts),
            let encrypted = try? AESUtility.encrypt(data, using: key)
        else {
            return
        }

        UserDefaults.standard.set(encrypted, forKey: storageKey)
    }
    
    static func add(accountName: String) {
        var accounts = load()
        let newAccount = StoredOTPAccount(accountName: accountName, dateAdded: Date())
        accounts.append(newAccount)
        save(accounts)
    }
    
    static func delete(accountName: String) {
        var accounts = load()
        accounts.removeAll { $0.accountName == accountName }
        save(accounts)
    }
    
    static func contains(accountName: String) -> Bool {
        return load().contains { $0.accountName == accountName }
    }
}
