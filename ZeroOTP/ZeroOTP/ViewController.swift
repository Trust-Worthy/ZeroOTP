//
//  ViewController.swift
//  ZeroOTP
//
//  Created by Trust-Worthy on 7/17/25.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
        
        accountTableView.register(OTPAccountCell.self, forCellReuseIdentifier: "OTPAccountCell")
        
        
        // Set datasource and delegate for the tableView
        accountTableView.delegate = self
        accountTableView.dataSource = self
        
    }
    // Call a method on this view controller when the button is tapped.”
    @objc func addAccountTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let addVC = storyboard.instantiateViewController(withIdentifier: "AddAccountViewController") as? AddAccountViewController {
            addVC.modalPresentationStyle = .automatic
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
        
        cell.accountLabel.text = ""
        cell.otpLabel.text = ""
        
        return cell
    }
    


}

