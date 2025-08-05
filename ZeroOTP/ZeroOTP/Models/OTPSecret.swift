//
//  OTPSecret.swift
//  ZeroOTP
//
//  Created by Trust-Worthy on 7/17/25.
//

import UIKit
import SwiftOTP
import CryptoKit

// MARK: - Prevent Secret Exposure in Logs / Prints
extension OTPSecret: CustomStringConvertible, CustomDebugStringConvertible {
    
    
    var description: String { "<Secret: hidden>" }
    var debugDescription: String { "<Secret: hidden>"}
}

extension OTPSecret {
    var symmetricKey: SymmetricKey {
        SymmetricKey(data: secretData)
    }
}

extension OTPSecret {
    init?(symmetricKey: SymmetricKey) {
        let keyData = symmetricKey.withUnsafeBytes { Data($0) }
        let base32String = base32Encode(keyData)
        
        self.init(base32String)
    }
}

extension OTPSecret {
    init?(secretData: Data) {
        let base32String = base32Encode(secretData)
        self.init(base32String)
    }
}


// MARK: - OTPSecret Struct: Represents a TOTP secret securely

struct OTPSecret {
    
    // Store Base32 string privately, avoid public exposure
    private let base32String: String
    
    
    // Store decoded secret data privately
    private let secretData: Data
    
    /// Initialize with a Base32 encoded secret string
    /// - Returns nil if input is invalid base32 or decoding fails
    init?(_ base32: String){
        
        // Trim whitespace, newlines and normalize to uppercase (Base32 standard)
        let trimmed = base32.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // Validate Base32 string to ensure only valid chars
        guard OTPSecret.isValidBase32(trimmed) else {
            return nil
        }
        
        // Decide base32 to Data securely
        guard let decodedData = base32DecodeToData(trimmed) else {
            return nil
        }
        
        self.base32String = trimmed
        self.secretData = decodedData
    }
    
    /// Provide secret data securely when needed
    /// The plaintext secret should be handled carefully and cleared ASAP by the caller
    func getSecretData() -> Data {
            return secretData
    }
        
    // Instance method for validation
    func isValid() -> Bool {
        OTPSecret.isValidBase32(base32String)
    }

    // MARK: Static Helper Functions
    
    /// Validate Base32 string format - ensures only valid chars and non-empty
    static func isValidBase32(_ string: String) -> Bool {
        let base32Charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567="
        
        // Base32 charset includes A-Z, 2-7 and optional padding '='
        return !string.isEmpty && string.allSatisfy { base32Charset.contains($0) }
    }
    
    
}



