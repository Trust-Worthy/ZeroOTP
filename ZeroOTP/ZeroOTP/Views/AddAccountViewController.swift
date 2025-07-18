//
//  AddAccountViewController.swift
//  ZeroOTP
//
//  Created by Jonathan Bateman on 7/17/25.
//

import UIKit

class AddAccountViewController: UIViewController {

    @IBAction func cancelTapped(_ sender: UIButton) {
            dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let secret = secretTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !secret.isEmpty else {
            showAlert(message: "Please enter a valid secret key.")
            return
        }
        
        guard isValidBase32(secret) else {
            showAlert(message: "Invalid Base32 TOTP secret.")
            return
        }
        
        print("User Input is saved...")
    }
    @IBOutlet weak var secretTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
    
    func isValidBase32(_ string: String) -> Bool {
        let base32Charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567="
        
        return string.uppercased().allSatisfy { base32Charset.contains($0) }
    }

    

}
