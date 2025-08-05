//
//  UserOTPAccounts.swift
//  ZeroOTP
//
//  Created by Trust-Worthy on 8/5/25.
//



struct UserOTPAccounts {
    
    static var userAccounts: [OTPAccount = <#initializer#>]
    
    
    static func getUserAccounts() -> [OTPAccount] {
        return userAccounts
    }
    
    static func saveAccount(otpAccount: OTPAccount) {
        
        
        userAccounts.append(otpAccount)
        
    }
    
    static func deleteAccount() {
        
    }
    
    func editAccountName() {
        return
    }
    
    func generateNewOTPSecret(){
        return
    }
}
