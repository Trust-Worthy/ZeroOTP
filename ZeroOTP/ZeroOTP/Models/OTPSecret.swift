//
//  OTPSecret.swift
//  ZeroOTP
//
//  Created by Trust-Worthy on 7/17/25.
//

import UIKit
import SwiftOTP



extension OTPSecret: CustomStringConvertible, CustomDebugStringConvertible {
    var description: String { "<Secret: hidden>" }
    var debugDescription: String { "<Secret: hidden>"}
}

struct OTPSecret {
    
    private let base32String: String
    
    let secretData: Data
    
    init?(_ base32: String){
        let trimmed = base32.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        guard OTPSecret.isValidBase32(trimmed) else {
            return nil
        }
        
        self.base32String = trimmed
        self.secretData = base32DecodeToData(base32String) ?? Data(hex: "0000000")
    }
    
    
    
    // Create the Save secret to user dafaults
    
    
    // Create the get / retrieve function for all of the
    
    // MARK: Instance Functions
    func validate() -> Bool {
            // Delegates to static function
            OTPSecret.isValidBase32(base32String)
        }
    
    // MARK: Static Functions
    private static func isValidBase32(_ string: String) -> Bool {
        let base32Charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567="
        return !string.isEmpty && string.allSatisfy { base32Charset.contains($0) }
    }
}
