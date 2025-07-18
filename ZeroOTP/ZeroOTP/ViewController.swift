//
//  ViewController.swift
//  ZeroOTP
//
//  Created by Trust-Worthy on 7/17/25.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var accountTableView: UITableView!
    
    var accounts: [OTPAccount] = []
    
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
        accountTableView.dataSource = self)
        
    }
    
    @objc func addAccountTapped() {
        print("Add button tapped!")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = "Row \(indexPath.row)"
        
        return cell
    }
    


}

