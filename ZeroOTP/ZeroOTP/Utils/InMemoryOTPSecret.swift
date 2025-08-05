//
//  InMemoryOTPSecret.swift
//  ZeroOTP
//
//  Created by Trust-Worthy on 8/4/25.
//


import Foundation
import CryptoKit

class InMemoryOTPSecret {
    
    private let key = SymmetricKey(size: .bits256)
    private var encryptedOTPSecret: Data // Still in binary form
    
    

    init?(otpSecret: String) {
        // takes a plain String secret
        // converts it into Data
        guard let secretData = otpSecret.data(using: .utf8) else {
            // if conversion failes (encoding error) , return nil
            return nil
        }
        
        do {
            // encrypts data using AES-GCM
            // sealedBox contains the ciphertext, nonce, and tag (authenticator)
            let sealedBox = try AES.GCM.seal(secretData, using: key)
            
            // .combined gives me a binary blob of ciphertext, none, and tag
            guard let combined = sealedBox.combined else {return nil}
            self.encryptedOTPSecret = combined
        } catch {
            return nil
        }
    }
    
    func revealOTPSecret() -> String? {
        do {
            // Reconstructs the sealed box from encrypted blob
            let sealedBox = try AES.GCM.SealedBox(combined: encryptedOTPSecret)
            let decryptedData: Data = try AES.GCM.open(sealedBox, using: key)
            
            // converts decrypted bytes back into a String
            return String(data: decryptedData, encoding: .utf8)
        } catch {
            return nil
        }
    }




    
}
