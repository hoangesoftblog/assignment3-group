//
//  PaymentCell.swift
//  assignment3-group
//
//  Created by Hoang, Truong Quoc on 5/6/19.
//  Copyright © 2019 Hoang, Truong Quoc. All rights reserved.
//

import UIKit

class PaymentCell: UITableViewCell {

    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var sendRequestLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var denyButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
