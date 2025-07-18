//
//  OTPAccountCell.swift
//  ZeroOTP
//
//  Created by Jonathan Bateman on 7/17/25.
//

import UIKit

class OTPAccountCell: UITableViewCell {

    
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var otpLabel: UILabel!
    @IBOutlet weak var timerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
