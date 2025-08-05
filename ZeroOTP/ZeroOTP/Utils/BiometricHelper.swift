//
//  BiometricHelper.swift
//  ZeroOTP
//
//  Created by Trust-Worthy on 8/5/25.
//

import LocalAuthentication

struct BiometricHelper {
    
    /// Authenticates the user using biometrics (Face ID / Touch ID / Passcode fallback)
    /// - Parameters:
    ///   - reason: The prompt shown to the user
    ///   - context: Optional `LAContext` (for injection/mocking)
    ///   - completion: Completion with success and optional error
    static func authenticate(
        reason: String = "Authenticate to access secret",
        context: LAContext = LAContext(),
        completion: @escaping (Bool, Error?) -> Void
    ) {
        var authError: NSError?
        
        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError)
        
        DispatchQueue.main.async {
            if canEvaluate {
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                    DispatchQueue.main.async {
                        completion(success, error)
                    }
                }
            } else {
                completion(false, authError)
            }
        }
    }
}

