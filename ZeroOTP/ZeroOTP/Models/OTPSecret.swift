//
//  OTPSecret.swift
//  ZeroOTP
//
//  Created by Trust-Worthy on 7/17/25.
//

import UIKit
import SwiftOTP



struct OTPSecret {
    
    let base32String: String
    
    var secretData: Data? {
        if validate() {
            return base32DecodeToData(base32String)
        }
    
        return nil
    }
    
    
    func validate() -> Bool {
        // Only allow valid base32 or hex secrets
        return !base32String.isEmpty && base32String.range(of: "^[A-Z2-7=]+$", options: .regularExpression) != nil
    }
    
    // Create the Save secret to user dafaults
    
    
    // Create the get / retrieve function for all of the
    
    
}
