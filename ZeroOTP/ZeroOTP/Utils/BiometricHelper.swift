//
//  BiometricHelper.swift
//  ZeroOTP
//
//  Created by Trust-Worthy on 8/5/25.
//


    
import LocalAuthentication

struct BiometricHelper {
    static func authenticate(_ reason: String = "Authenticate to access secret", completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authError in
                DispatchQueue.main.async {
                    completion(success, authError)
                }
            }
        } else {
            completion(false, error)
        }
    }
}


