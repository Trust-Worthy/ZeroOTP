//
//  SecureOTPStore.swift
//  ZeroOTP
//
//  Created by Trust-Worthy on 8/5/25.
//

import Foundation
import CryptoKit

final class SecureOTPStore {
    
    static let shared = SecureOTPStore()
    private var unwrappedSecrets: [String: OTPSecret] = [:]
    private var timer: Timer?

    private init() {}

    /// Adds a new OTP account by wrapping and storing its secret
    func addAccount(accountName: String, secret: OTPSecret) -> Bool {
        guard let key = SecureEnclaveHelper.getSecureEnclaveKey() ?? SecureEnclaveHelper.generateAndStoreSecureEnclaveKey() else {
            return false
        }

        guard let wrappedKey = SecureEnclaveHelper.wrapKey(secret.symmetricKey) else {
            return false
        }

        let storeKey = "otp.secret.\(accountName)"
        return KeychainHelper.storeWrappedKey(wrappedKey, forKey: storeKey)
    }

    /// Unlocks and temporarily caches the secret after biometric auth
    func unlockSecret(for accountName: String, completion: @escaping (OTPSecret?) -> Void) {
        let storeKey = "otp.secret.\(accountName)"
        
        BiometricHelper.authenticate(reason: "Authenticate to reveal OTP") { [weak self] success, _ in
            guard success,
                  let wrapped = KeychainHelper.loadWrappedKey(forKey: storeKey),
                  let symmetricKey = SecureEnclaveHelper.unwrapKey(wrapped),
                  let secret = OTPSecret(symmetricKey: symmetricKey) else {
                completion(nil)
                return
            }

            self?.cacheSecret(secret, forKey: accountName)
            completion(secret)
        }
    }

    /// Temporarily caches the secret (in-memory, auto-clears after 30 seconds)
    private func cacheSecret(_ secret: OTPSecret, forKey key: String) {
        unwrappedSecrets[key] = secret

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: false) { [weak self] _ in
            self?.unwrappedSecrets.removeAll()
        }
    }

    /// Used by OTPAccount to pull cached secret for code generation
    func getUnwrappedSecret(for accountName: String) -> OTPSecret? {
        return unwrappedSecrets[accountName]
    }

    /// Wipes secrets manually (e.g., app goes background or logout)
    func clearSecrets() {
        unwrappedSecrets.removeAll()
        timer?.invalidate()
        timer = nil
    }
}

