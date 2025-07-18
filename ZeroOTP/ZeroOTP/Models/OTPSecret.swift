//
//  OTPSecret.swift
//  ZeroOTP
//
//  Created by Trust-Worthy on 7/17/25.
//

protocol OTPSecret {
    var secret: String { get }
    func validate() -> Bool
}

extension OTPSecret {
    func validate() -> Bool {
        // Only allow valid base32 or hex secrets
        return !secret.isEmpty && secret.range(of: "^[A-Z2-7=]+$", options: .regularExpression) != nil
    }
}
