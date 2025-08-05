//
//  ViewController.swift
//  ZeroOTP
//
//  Created by Trust-Worthy on 7/17/25.
//

import UIKit
import SwiftOTP
import SamplePackage

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddAccountDelegate {
    
    
    func didAddAccount(_ account: OTPAccount) {
        OTPAccounts.append(account)
        accountTableView.reloadData()
    }
    
    
    // MARK: Class properties
    // Tabel View to display the different OTP accounts user has
    @IBOutlet weak var accountTableView: UITableView!
    
    // OTP Account data that will be displayed in the table view
    var OTPAccounts: [OTPAccount] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set title for the navigation bar
        self.title = "ZeroOTP"
        
        // Add a "+" button to the right of the nav bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addAccountTapped))
        
        
        
        // Set datasource and delegate for the tableView
        accountTableView.delegate = self
        accountTableView.dataSource = self

        
    }
    
    // Call a method on this view controller when the button is tapped.”
    @objc func addAccountTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Take user to the add OTP view controller.
        if let addVC = storyboard.instantiateViewController(withIdentifier: "AddAccountViewController") as? AddAccountViewController {
            addVC.modalPresentationStyle = .automatic
            addVC.delegate = self // ✅ Set delegate here
            self.present(addVC, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OTPAccounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OTPAccountCell", for: indexPath) as? OTPAccountCell else {
            fatalError("Could not dequeue OTPAccountCell")
        }
        
        let account = OTPAccounts[indexPath.row]
        
        
        cell.accountLabel.text = account.accountName
        // MARK: TO-DO
        // Generate the secret
//        cell.otpLabel.text = generateOTP(from: account.secret) // You’ll implement this later
        // MARK: TO-DO
        // Make sure that account.secret can't be printed or displayed EVER
        cell.otpLabel.text = account.secret
        
        return cell
    }
    
    
    // MARK: TO-DO
    // Add a feature that reminds the user to export their codes and back them up in case something happens
    // to their device

}

