//
//  InMemoryOTPSecret.swift
//  ZeroOTP
//
//  Created by Trust-Worthy on 8/4/25.
//


import Foundation
import CryptoKit

class InMemoryOTPSecret {
    
    private var encryptedOTPSecret: Data // Still in binary form
    private var wrappedSymmetricKey: Data
    

    init?(otpSecret: String) {
        
        // takes a plain String secret
        // converts it into Data
        guard let secretData = otpSecret.data(using: .utf8) else {
            // if conversion failes (encoding error) , return nil
            return nil
        }
        
        let symmetricKey = SymmetricKey(size: .bits256)
        
        do {
            // encrypts data using AES-GCM
            // sealedBox contains the ciphertext, nonce, and tag (authenticator)
            let sealedBox = try AES.GCM.seal(secretData, using: symmetricKey)
            
            // .combined gives me a binary blob of ciphertext, none, and tag
            guard let combined = sealedBox.combined else {return nil}
            self.encryptedOTPSecret = combined
            
            guard let wrapped = SecureEnclaveHelper.wrapKey(symmetricKey) else {return nil}
            self.wrappedSymmetricKey = wrapped
            
            // Save the encryptedOTPSecret & the wrapped SymmetricKey
            UserDefaults.standard.set(encryptedOTPSecret, forKey: "otp_secret")
            UserDefaults.standard.set(wrappedSymmetricKey, forKey: "wrapped_key")
            
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
    
    static func loadSecret(completion: @escaping (String?) -> Void) {
        
        
    }




    
}
